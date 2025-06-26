/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonSyntaxException;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author ankha
 */
/**
 * Service for interacting with Google Gemini AI API Handles question generation
 * and chat functionality
 */
public class GeminiAIService {

    private static final Logger logger = Logger.getLogger(GeminiAIService.class.getName());

    // Replace with your actual Gemini API key from Google AI Studio
    private static final String API_KEY = "YOUR_API_KEY_HERE"; // Enter ur actual API KEY
    private static final String MODEL = "gemini-2.5-flash";
    private static final String API_URL = "https://generativelanguage.googleapis.com/v1beta/models/" + MODEL + ":generateContent";

    private final HttpClient httpClient;
    private final Gson gson;
    private final JsonParser jsonParser;

    public GeminiAIService() {
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(30))
                .build();
        this.gson = new Gson();
        this.jsonParser = new JsonParser();
    }

    /**
     * Generate questions using AI based on the provided request
     */
    public List<AIQuestion> generateQuestions(AIGenerationRequest request) throws Exception {
        logger.info("Generating " + request.getNumberOfQuestions() + " questions of type: " + request.getQuestionType());

        String prompt = buildPrompt(request);
        String response = callGeminiAPI(prompt);
        return parseAIResponse(response, request.getQuestionType());
    }

    /**
     * Build the prompt for AI question generation
     */
    private String buildPrompt(AIGenerationRequest request) {
        StringBuilder prompt = new StringBuilder();

        prompt.append("You are an expert educator. Generate ").append(request.getNumberOfQuestions())
                .append(" ").append(request.getDifficulty()).append(" level educational questions ")
                .append("for Grade: ").append(request.getGradeName())
                .append(", Subject: ").append(request.getSubjectName())
                .append(", Lesson: ").append(request.getLessonName()).append("\n\n");

        prompt.append("Lesson Content:\n").append(request.getLessonContent()).append("\n\n");

        // Question type specific instructions
        switch (request.getQuestionType().toLowerCase()) {
            case "single_choice":
                prompt.append("Generate SINGLE CHOICE questions with exactly 4 options (A, B, C, D). ")
                        .append("Only ONE option should be correct. Each question should test understanding of key concepts.\n");
                break;
            case "multiple_choice":
                prompt.append("Generate MULTIPLE CHOICE questions with 4-5 options. ")
                        .append("2-3 options should be correct. These questions should test comprehensive understanding.\n");
                break;
            case "true_false":
                prompt.append("Generate TRUE/FALSE questions with only 2 options: 'True' and 'False'. ")
                        .append("Only one option should be correct. Focus on factual statements from the lesson.\n");
                break;
            default:
                prompt.append("Generate educational questions with multiple options.\n");
                break;
        }

        if (request.getAdditionalInstructions() != null && !request.getAdditionalInstructions().trim().isEmpty()) {
            prompt.append("\nAdditional Instructions: ").append(request.getAdditionalInstructions()).append("\n");
        }

        prompt.append("\nCRITICAL: You MUST respond with ONLY a valid JSON array. No additional text before or after.\n");
        prompt.append("Use this EXACT format:\n");
        prompt.append("[\n");
        prompt.append("  {\n");
        prompt.append("    \"question\": \"Clear, well-written question text\",\n");
        prompt.append("    \"options\": [\"Option 1\", \"Option 2\", \"Option 3\", \"Option 4\"],\n");
        prompt.append("    \"correctAnswers\": [0, 2],\n");
        prompt.append("    \"explanation\": \"Clear explanation of why the answer is correct\"\n");
        prompt.append("  }\n");
        prompt.append("]\n\n");
        prompt.append("IMPORTANT RULES:\n");
        prompt.append("- correctAnswers contains array indices (0-based) of correct options\n");
        prompt.append("- For single choice: correctAnswers should have exactly 1 index\n");
        prompt.append("- For multiple choice: correctAnswers should have 2-3 indices\n");
        prompt.append("- For true/false: correctAnswers should have exactly 1 index (0 or 1)\n");
        prompt.append("- Respond with ONLY the JSON array, no markdown formatting, no extra text\n");

        return prompt.toString();
    }

    /**
     * Call the Gemini API with the given prompt
     */
    private String callGeminiAPI(String prompt) throws Exception {
        logger.info("Calling Gemini API...");

        // Create request body with safety settings
        JsonObject requestBody = new JsonObject();
        JsonArray contents = new JsonArray();
        JsonObject requestContent = new JsonObject();
        JsonArray requestParts = new JsonArray();
        JsonObject part = new JsonObject();

        part.addProperty("text", prompt);
        requestParts.add(part);
        requestContent.add("parts", requestParts);
        contents.add(requestContent);
        requestBody.add("contents", contents);

        // Add generation config for better responses
        JsonObject generationConfig = new JsonObject();
        generationConfig.addProperty("temperature", 0.3); // Lower temperature for more consistent JSON
        generationConfig.addProperty("topK", 20);
        generationConfig.addProperty("topP", 0.8);
        generationConfig.addProperty("maxOutputTokens", 4096);
        requestBody.add("generationConfig", generationConfig);

        // Add safety settings to prevent blocking
        JsonArray safetySettings = new JsonArray();
        String[] categories = {
            "HARM_CATEGORY_HARASSMENT",
            "HARM_CATEGORY_HATE_SPEECH",
            "HARM_CATEGORY_SEXUALLY_EXPLICIT",
            "HARM_CATEGORY_DANGEROUS_CONTENT"
        };

        for (String category : categories) {
            JsonObject safetySetting = new JsonObject();
            safetySetting.addProperty("category", category);
            safetySetting.addProperty("threshold", "BLOCK_NONE");
            safetySettings.add(safetySetting);
        }
        requestBody.add("safetySettings", safetySettings);

        logger.info("Request body: " + requestBody.toString());

        // Create HTTP request
        HttpRequest httpRequest = HttpRequest.newBuilder()
                .uri(URI.create(API_URL + "?key=" + API_KEY))
                .header("Content-Type", "application/json")
                .timeout(Duration.ofSeconds(60))
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();

        // Send request and get response
        HttpResponse<String> httpResponse = httpClient.send(httpRequest, HttpResponse.BodyHandlers.ofString());

        logger.info("API Response Status: " + httpResponse.statusCode());
        logger.info("API Response Body: " + httpResponse.body());

        if (httpResponse.statusCode() != 200) {
            String errorMsg = "API call failed with status: " + httpResponse.statusCode()
                    + ", body: " + httpResponse.body();
            logger.severe(errorMsg);
            throw new Exception(errorMsg);
        }

        // Parse response to extract generated text
        String generatedText = extractGeneratedText(httpResponse.body());
        logger.info("Generated text: " + generatedText);

        return generatedText;
    }

    /**
     * Extract generated text from API response with robust error handling
     */
    private String extractGeneratedText(String responseBody) throws Exception {
        try {
            JsonObject responseJson = jsonParser.parse(responseBody).getAsJsonObject();

            // Check for API errors
            if (responseJson.has("error")) {
                JsonObject error = responseJson.getAsJsonObject("error");
                String errorMessage = error.has("message") ? error.get("message").getAsString() : "Unknown API error";
                throw new Exception("API Error: " + errorMessage);
            }

            // Check if response was blocked by safety filters
            if (!responseJson.has("candidates") || responseJson.getAsJsonArray("candidates").size() == 0) {
                logger.warning("No candidates in response - possibly blocked by safety filters");
                throw new Exception("Response was blocked by safety filters or no content generated");
            }

            JsonArray candidates = responseJson.getAsJsonArray("candidates");
            JsonObject candidate = candidates.get(0).getAsJsonObject();

            // Check finish reason
            if (candidate.has("finishReason")) {
                String finishReason = candidate.get("finishReason").getAsString();
                if (!"STOP".equals(finishReason)) {
                    logger.warning("Generation finished with reason: " + finishReason);
                    if ("SAFETY".equals(finishReason)) {
                        throw new Exception("Content was blocked by safety filters");
                    }
                }
            }

            // Extract content
            if (!candidate.has("content")) {
                throw new Exception("No content in candidate response");
            }

            JsonObject responseContent = candidate.getAsJsonObject("content");

            if (!responseContent.has("parts")) {
                throw new Exception("No parts in content response");
            }

            JsonArray responseParts = responseContent.getAsJsonArray("parts");

            if (responseParts == null || responseParts.size() == 0) {
                throw new Exception("Response parts array is null or empty");
            }

            JsonObject firstPart = responseParts.get(0).getAsJsonObject();

            if (!firstPart.has("text")) {
                throw new Exception("No text in response part");
            }

            String generatedText = firstPart.get("text").getAsString();

            if (generatedText == null || generatedText.trim().isEmpty()) {
                throw new Exception("Generated text is null or empty");
            }

            return generatedText;

        } catch (JsonSyntaxException e) {
            logger.severe("Failed to parse API response as JSON: " + e.getMessage());
            throw new Exception("Invalid JSON response from API: " + e.getMessage());
        } catch (Exception e) {
            logger.severe("Error extracting generated text: " + e.getMessage());
            throw e;
        }
    }

    /**
     * Parse AI response into question objects with robust error handling
     */
    private List<AIQuestion> parseAIResponse(String response, String questionType) {
        List<AIQuestion> questions = new ArrayList<>();

        try {
            logger.info("Parsing AI response for question type: " + questionType);
            logger.info("Raw response: " + response.substring(0, Math.min(500, response.length())));

            // Clean and extract JSON from response
            String jsonStr = extractAndCleanJSON(response);
            logger.info("Cleaned JSON: " + jsonStr);

            if (jsonStr == null || jsonStr.trim().isEmpty()) {
                logger.warning("No valid JSON found in response");
                return createFallbackQuestions(questionType, 3);
            }

            // Parse JSON array
            JsonArray questionsArray = jsonParser.parse(jsonStr).getAsJsonArray();

            if (questionsArray == null || questionsArray.size() == 0) {
                logger.warning("Parsed JSON array is null or empty");
                return createFallbackQuestions(questionType, 3);
            }

            // Process each question
            for (int i = 0; i < questionsArray.size(); i++) {
                try {
                    JsonObject questionObj = questionsArray.get(i).getAsJsonObject();
                    AIQuestion question = parseQuestionObject(questionObj, questionType);
                    if (question != null) {
                        questions.add(question);
                        logger.info("Successfully parsed question " + (i + 1) + ": "
                                + question.getQuestion().substring(0, Math.min(50, question.getQuestion().length())) + "...");
                    }
                } catch (Exception e) {
                    logger.warning("Failed to parse question " + (i + 1) + ": " + e.getMessage());
                    // Continue with other questions
                }
            }

        } catch (JsonSyntaxException e) {
            logger.log(Level.WARNING, "JSON parsing error: " + e.getMessage(), e);
            return createFallbackQuestions(questionType, 3);
        } catch (Exception e) {
            logger.log(Level.WARNING, "Error parsing AI response: " + e.getMessage(), e);
            return createFallbackQuestions(questionType, 3);
        }

        // If no questions were successfully parsed, create fallback
        if (questions.isEmpty()) {
            logger.warning("No questions were successfully parsed, creating fallback questions");
            return createFallbackQuestions(questionType, 3);
        }

        logger.info("Successfully parsed " + questions.size() + " questions");
        return questions;
    }

    /**
     * Extract and clean JSON from AI response
     */
    private String extractAndCleanJSON(String response) {
        if (response == null || response.trim().isEmpty()) {
            return null;
        }

        // Remove markdown code block markers if present
        response = response.replaceAll("```json\\s*", "").replaceAll("```\\s*$", "");

        // Find JSON array boundaries
        int startIndex = response.indexOf("[");
        int endIndex = response.lastIndexOf("]");

        if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
            String jsonStr = response.substring(startIndex, endIndex + 1).trim();

            // Basic validation - check if it looks like valid JSON
            if (jsonStr.startsWith("[") && jsonStr.endsWith("]")) {
                return jsonStr;
            }
        }

        // If no proper JSON array found, try to find any JSON-like structure
        if (response.contains("{") && response.contains("}")) {
            // Try to wrap in array if it's a single object
            String trimmed = response.trim();
            if (trimmed.startsWith("{") && trimmed.endsWith("}")) {
                return "[" + trimmed + "]";
            }
        }

        logger.warning("Could not extract valid JSON from response");
        return null;
    }

    /**
     * Parse individual question object from JSON
     */
    private AIQuestion parseQuestionObject(JsonObject questionObj, String questionType) {
        try {
            AIQuestion question = new AIQuestion();

            // Parse question text
            if (!questionObj.has("question")) {
                logger.warning("Question object missing 'question' field");
                return null;
            }
            question.setQuestion(questionObj.get("question").getAsString());

            // Parse explanation
            String explanation = questionObj.has("explanation")
                    ? questionObj.get("explanation").getAsString() : "No explanation provided.";
            question.setExplanation(explanation);

            question.setQuestionType(questionType);

            // Parse options
            if (!questionObj.has("options")) {
                logger.warning("Question object missing 'options' field");
                return null;
            }

            JsonArray optionsArray = questionObj.getAsJsonArray("options");
            List<String> options = new ArrayList<>();
            for (int j = 0; j < optionsArray.size(); j++) {
                options.add(optionsArray.get(j).getAsString());
            }
            question.setOptions(options);

            // Parse correct answers
            List<Integer> correctAnswers = new ArrayList<>();
            if (questionObj.has("correctAnswers")) {
                JsonArray correctArray = questionObj.getAsJsonArray("correctAnswers");
                for (int j = 0; j < correctArray.size(); j++) {
                    correctAnswers.add(correctArray.get(j).getAsInt());
                }
            } else {
                // Fallback: assume first option is correct
                correctAnswers.add(0);
            }

            // Validate correct answers
            correctAnswers = validateCorrectAnswers(correctAnswers, options.size(), questionType);
            question.setCorrectAnswers(correctAnswers);

            // Set legacy correctAnswerIndex for backward compatibility
            if (!correctAnswers.isEmpty()) {
                question.setCorrectAnswerIndex(correctAnswers.get(0));
            }

            return question;

        } catch (Exception e) {
            logger.warning("Error parsing question object: " + e.getMessage());
            return null;
        }
    }

    /**
     * Validate and fix correct answers based on question type
     */
    private List<Integer> validateCorrectAnswers(List<Integer> correctAnswers, int optionCount, String questionType) {
        List<Integer> validAnswers = new ArrayList<>();

        // Filter out invalid indices
        for (Integer answer : correctAnswers) {
            if (answer != null && answer >= 0 && answer < optionCount) {
                validAnswers.add(answer);
            }
        }

        // Apply question type rules
        switch (questionType.toLowerCase()) {
            case "single_choice":
            case "true_false":
                // Should have exactly 1 correct answer
                if (validAnswers.isEmpty()) {
                    validAnswers.add(0); // Default to first option
                } else if (validAnswers.size() > 1) {
                    // Keep only the first correct answer
                    validAnswers = validAnswers.subList(0, 1);
                }
                break;

            case "multiple_choice":
                // Should have at least 1 correct answer
                if (validAnswers.isEmpty()) {
                    validAnswers.add(0); // Default to first option
                }
                // For multiple choice, we allow multiple correct answers
                break;

            default:
                // Default behavior
                if (validAnswers.isEmpty()) {
                    validAnswers.add(0);
                }
                break;
        }

        return validAnswers;
    }

    /**
     * Create fallback questions when AI generation fails
     */
    private List<AIQuestion> createFallbackQuestions(String questionType, int count) {
        List<AIQuestion> questions = new ArrayList<>();

        for (int i = 0; i < count; i++) {
            AIQuestion question = new AIQuestion();
            question.setQuestion("Sample question " + (i + 1) + " (AI generation fallback) - Please edit this question to match your lesson content.");
            question.setExplanation("This is a fallback question created when AI response parsing failed. Please edit both the question and explanation to match your lesson content.");
            question.setQuestionType(questionType);

            // Create options based on question type
            List<String> options = new ArrayList<>();
            List<Integer> correctAnswers = new ArrayList<>();

            switch (questionType.toLowerCase()) {
                case "true_false":
                    options.add("True");
                    options.add("False");
                    correctAnswers.add(0);
                    break;
                case "multiple_choice":
                    options.add("Option A - Please edit this option");
                    options.add("Option B - Please edit this option");
                    options.add("Option C - Please edit this option");
                    options.add("Option D - Please edit this option");
                    correctAnswers.add(0);
                    correctAnswers.add(2); // Multiple correct answers
                    break;
                default: // single_choice
                    options.add("Option A - Please edit this option");
                    options.add("Option B - Please edit this option");
                    options.add("Option C - Please edit this option");
                    options.add("Option D - Please edit this option");
                    correctAnswers.add(0);
                    break;
            }

            question.setOptions(options);
            question.setCorrectAnswers(correctAnswers);
            question.setCorrectAnswerIndex(correctAnswers.get(0));
            questions.add(question);
        }

        return questions;
    }

    /**
     * Chat with AI functionality
     */
    public String chatWithAI(String message, String context) throws Exception {
        String prompt = "Context: " + context + "\n\nUser question: " + message
                + "\n\nPlease provide a helpful response about improving or understanding the educational content. "
                + "Keep your response concise and practical.";

        try {
            return callGeminiAPI(prompt);
        } catch (Exception e) {
            logger.log(Level.WARNING, "Chat with AI failed", e);
            return "I'm sorry, I'm having trouble responding right now. Please try rephrasing your question or try again later.";
        }
    }

    // Inner classes remain the same
    public static class AIGenerationRequest {

        private String gradeName;
        private String subjectName;
        private String lessonName;
        private String lessonContent;
        private int numberOfQuestions;
        private String difficulty;
        private String questionType;
        private String additionalInstructions;

        // Getters and setters
        public String getGradeName() {
            return gradeName;
        }

        public void setGradeName(String gradeName) {
            this.gradeName = gradeName;
        }

        public String getSubjectName() {
            return subjectName;
        }

        public void setSubjectName(String subjectName) {
            this.subjectName = subjectName;
        }

        public String getLessonName() {
            return lessonName;
        }

        public void setLessonName(String lessonName) {
            this.lessonName = lessonName;
        }

        public String getLessonContent() {
            return lessonContent;
        }

        public void setLessonContent(String lessonContent) {
            this.lessonContent = lessonContent;
        }

        public int getNumberOfQuestions() {
            return numberOfQuestions;
        }

        public void setNumberOfQuestions(int numberOfQuestions) {
            this.numberOfQuestions = numberOfQuestions;
        }

        public String getDifficulty() {
            return difficulty;
        }

        public void setDifficulty(String difficulty) {
            this.difficulty = difficulty;
        }

        public String getQuestionType() {
            return questionType;
        }

        public void setQuestionType(String questionType) {
            this.questionType = questionType;
        }

        public String getAdditionalInstructions() {
            return additionalInstructions;
        }

        public void setAdditionalInstructions(String additionalInstructions) {
            this.additionalInstructions = additionalInstructions;
        }
    }

    public static class AIQuestion {

        private String question;
        private List<String> options;
        private List<Integer> correctAnswers;
        private int correctAnswerIndex;
        private String explanation;
        private String questionType;

        // Getters and setters
        public String getQuestion() {
            return question;
        }

        public void setQuestion(String question) {
            this.question = question;
        }

        public List<String> getOptions() {
            return options;
        }

        public void setOptions(List<String> options) {
            this.options = options;
        }

        public List<Integer> getCorrectAnswers() {
            return correctAnswers;
        }

        public void setCorrectAnswers(List<Integer> correctAnswers) {
            this.correctAnswers = correctAnswers;
        }

        public int getCorrectAnswerIndex() {
            return correctAnswerIndex;
        }

        public void setCorrectAnswerIndex(int correctAnswerIndex) {
            this.correctAnswerIndex = correctAnswerIndex;
        }

        public String getExplanation() {
            return explanation;
        }

        public void setExplanation(String explanation) {
            this.explanation = explanation;
        }

        public String getQuestionType() {
            return questionType;
        }

        public void setQuestionType(String questionType) {
            this.questionType = questionType;
        }
    }
}
