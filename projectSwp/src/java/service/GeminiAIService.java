/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
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
public class GeminiAIService {

    private static final Logger logger = Logger.getLogger(GeminiAIService.class.getName());

    // Replace with your actual Gemini API key from Google AI Studio
    private static final String API_KEY = "AIzaSyBMZqqgfbxZw9SD6Zd2i8dObIKUtVhIIa8";
    private static final String MODEL = "gemini-2.5-flash";
    private static final String API_URL = "https://generativelanguage.googleapis.com/v1beta/models/" + MODEL + ":generateContent";

    private final HttpClient httpClient;
    private final Gson gson;
    private final JsonParser jsonParser; // Add JsonParser instance

    public GeminiAIService() {
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(30))
                .build();
        this.gson = new Gson();
        this.jsonParser = new JsonParser(); // Initialize JsonParser
    }

    public List<AIQuestion> generateQuestions(AIGenerationRequest request) throws Exception {
        logger.info("Generating " + request.getNumberOfQuestions() + " questions of type: " + request.getQuestionType());

        String prompt = buildPrompt(request);
        String response = callGeminiAPI(prompt);
        return parseAIResponse(response, request.getQuestionType());
    }

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

        prompt.append("\nIMPORTANT: Respond with ONLY a valid JSON array in this exact format:\n");
        prompt.append("[\n");
        prompt.append("  {\n");
        prompt.append("    \"question\": \"Clear, well-written question text\",\n");
        prompt.append("    \"options\": [\"Option 1\", \"Option 2\", \"Option 3\", \"Option 4\"],\n");
        prompt.append("    \"correctAnswers\": [0, 2],\n");
        prompt.append("    \"explanation\": \"Clear explanation of why the answer is correct\"\n");
        prompt.append("  }\n");
        prompt.append("]\n");
        prompt.append("\nDo not include any text before or after the JSON array.");

        return prompt.toString();
    }

    private String callGeminiAPI(String prompt) throws Exception {
        logger.info("Calling Gemini API...");

        // Create request body
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
        generationConfig.addProperty("temperature", 0.7);
        generationConfig.addProperty("topK", 40);
        generationConfig.addProperty("topP", 0.95);
        generationConfig.addProperty("maxOutputTokens", 2048);
        requestBody.add("generationConfig", generationConfig);

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

        if (httpResponse.statusCode() != 200) {
            String errorMsg = "API call failed with status: " + httpResponse.statusCode()
                    + ", body: " + httpResponse.body();
            logger.severe(errorMsg);
            throw new Exception(errorMsg);
        }

        // Parse response to extract generated text - FIXED VERSION
        JsonObject responseJson = jsonParser.parse(httpResponse.body()).getAsJsonObject();

        if (!responseJson.has("candidates")) {
            throw new Exception("No candidates in API response");
        }

        JsonArray candidates = responseJson.getAsJsonArray("candidates");

        if (candidates.size() == 0) {
            throw new Exception("No candidates returned by API");
        }

        JsonObject candidate = candidates.get(0).getAsJsonObject();

        if (!candidate.has("content")) {
            throw new Exception("No content in candidate response");
        }

        JsonObject responseContent = candidate.getAsJsonObject("content");
        JsonArray responseParts = responseContent.getAsJsonArray("parts");

        if (responseParts.size() == 0) {
            throw new Exception("No parts in content response");
        }

        String generatedText = responseParts.get(0).getAsJsonObject().get("text").getAsString();
        logger.info("Generated text length: " + generatedText.length());

        return generatedText;
    }

    private List<AIQuestion> parseAIResponse(String response, String questionType) {
        List<AIQuestion> questions = new ArrayList<>();

        try {
            logger.info("Parsing AI response...");

            // Extract JSON from response (AI might include additional text)
            String jsonStr = extractJSON(response);
            logger.info("Extracted JSON: " + jsonStr.substring(0, Math.min(200, jsonStr.length())) + "...");

            // FIXED: Use jsonParser.parse() instead of JsonParser.parseString()
            JsonArray questionsArray = jsonParser.parse(jsonStr).getAsJsonArray();

            for (int i = 0; i < questionsArray.size(); i++) {
                JsonObject questionObj = questionsArray.get(i).getAsJsonObject();

                AIQuestion question = new AIQuestion();
                question.setQuestion(questionObj.get("question").getAsString());
                question.setExplanation(questionObj.get("explanation").getAsString());
                question.setQuestionType(questionType);

                // Parse options
                JsonArray optionsArray = questionObj.getAsJsonArray("options");
                List<String> options = new ArrayList<>();
                for (int j = 0; j < optionsArray.size(); j++) {
                    options.add(optionsArray.get(j).getAsString());
                }
                question.setOptions(options);

                // Parse correct answers
                JsonArray correctArray = questionObj.getAsJsonArray("correctAnswers");
                List<Integer> correctAnswers = new ArrayList<>();
                for (int j = 0; j < correctArray.size(); j++) {
                    correctAnswers.add(correctArray.get(j).getAsInt());
                }
                question.setCorrectAnswers(correctAnswers);

                // Set legacy correctAnswerIndex for backward compatibility
                if (!correctAnswers.isEmpty()) {
                    question.setCorrectAnswerIndex(correctAnswers.get(0));
                }

                questions.add(question);
                logger.info("Parsed question " + (i + 1) + ": " + question.getQuestion().substring(0, Math.min(50, question.getQuestion().length())) + "...");
            }

        } catch (Exception e) {
            logger.log(Level.WARNING, "Error parsing AI response, creating fallback questions", e);
            // Create fallback questions if parsing fails
            questions = createFallbackQuestions(questionType, 3);
        }

        return questions;
    }

    private String extractJSON(String response) {
        // Find JSON array in the response
        int startIndex = response.indexOf("[");
        int endIndex = response.lastIndexOf("]") + 1;

        if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
            return response.substring(startIndex, endIndex);
        }

        // If no JSON found, return a fallback structure
        logger.warning("No JSON array found in response, using fallback");
        return "[{\"question\":\"Sample question from lesson content\",\"options\":[\"Option A\",\"Option B\",\"Option C\",\"Option D\"],\"correctAnswers\":[0],\"explanation\":\"This is a sample explanation.\"}]";
    }

    private List<AIQuestion> createFallbackQuestions(String questionType, int count) {
        List<AIQuestion> questions = new ArrayList<>();

        for (int i = 0; i < count; i++) {
            AIQuestion question = new AIQuestion();
            question.setQuestion("Sample question " + (i + 1) + " (AI generation fallback)");
            question.setExplanation("This is a fallback question created when AI response parsing failed. Please edit this question.");
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
                    options.add("Option A");
                    options.add("Option B");
                    options.add("Option C");
                    options.add("Option D");
                    correctAnswers.add(0);
                    correctAnswers.add(2); // Multiple correct answers
                    break;
                default: // single_choice
                    options.add("Option A");
                    options.add("Option B");
                    options.add("Option C");
                    options.add("Option D");
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

    // Inner classes
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
        private List<Integer> correctAnswers; // Support multiple correct answers
        private int correctAnswerIndex; // For backward compatibility
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
