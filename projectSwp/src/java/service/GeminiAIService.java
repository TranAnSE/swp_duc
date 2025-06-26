/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package service;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
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
    private static final String GEMINI_API_KEY = "AIzaSyBMZqqgfbxZw9SD6Zd2i8dObIKUtVhIIa8"; // Replace with your actual API key
    private static final String GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent";
    
    public static class AIQuestion {
        private String question;
        private List<String> options;
        private int correctAnswerIndex;
        private String explanation;
        
        public AIQuestion() {
            this.options = new ArrayList<>();
        }
        
        // Getters and setters
        public String getQuestion() { return question; }
        public void setQuestion(String question) { this.question = question; }
        public List<String> getOptions() { return options; }
        public void setOptions(List<String> options) { this.options = options; }
        public int getCorrectAnswerIndex() { return correctAnswerIndex; }
        public void setCorrectAnswerIndex(int correctAnswerIndex) { this.correctAnswerIndex = correctAnswerIndex; }
        public String getExplanation() { return explanation; }
        public void setExplanation(String explanation) { this.explanation = explanation; }
    }
    
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
        public String getGradeName() { return gradeName; }
        public void setGradeName(String gradeName) { this.gradeName = gradeName; }
        public String getSubjectName() { return subjectName; }
        public void setSubjectName(String subjectName) { this.subjectName = subjectName; }
        public String getLessonName() { return lessonName; }
        public void setLessonName(String lessonName) { this.lessonName = lessonName; }
        public String getLessonContent() { return lessonContent; }
        public void setLessonContent(String lessonContent) { this.lessonContent = lessonContent; }
        public int getNumberOfQuestions() { return numberOfQuestions; }
        public void setNumberOfQuestions(int numberOfQuestions) { this.numberOfQuestions = numberOfQuestions; }
        public String getDifficulty() { return difficulty; }
        public void setDifficulty(String difficulty) { this.difficulty = difficulty; }
        public String getQuestionType() { return questionType; }
        public void setQuestionType(String questionType) { this.questionType = questionType; }
        public String getAdditionalInstructions() { return additionalInstructions; }
        public void setAdditionalInstructions(String additionalInstructions) { this.additionalInstructions = additionalInstructions; }
    }
    
    public List<AIQuestion> generateQuestions(AIGenerationRequest request) throws Exception {
        String prompt = buildPrompt(request);
        String response = callGeminiAPI(prompt);
        return parseQuestionsFromResponse(response);
    }
    
    public String chatWithAI(String message, String context) throws Exception {
        String prompt = buildChatPrompt(message, context);
        return callGeminiAPI(prompt);
    }
    
    private String buildPrompt(AIGenerationRequest request) {
        StringBuilder prompt = new StringBuilder();
        prompt.append("You are an expert education content creator. Generate ")
              .append(request.getNumberOfQuestions())
              .append(" multiple choice questions for the following lesson:\n\n");
        
        prompt.append("Grade: ").append(request.getGradeName()).append("\n");
        prompt.append("Subject: ").append(request.getSubjectName()).append("\n");
        prompt.append("Lesson: ").append(request.getLessonName()).append("\n");
        prompt.append("Lesson Content: ").append(request.getLessonContent()).append("\n");
        prompt.append("Difficulty: ").append(request.getDifficulty()).append("\n");
        prompt.append("Question Type: ").append(request.getQuestionType()).append("\n");
        
        if (request.getAdditionalInstructions() != null && !request.getAdditionalInstructions().trim().isEmpty()) {
            prompt.append("Additional Instructions: ").append(request.getAdditionalInstructions()).append("\n");
        }
        
        prompt.append("\nPlease generate questions in the following JSON format:\n");
        prompt.append("{\n");
        prompt.append("  \"questions\": [\n");
        prompt.append("    {\n");
        prompt.append("      \"question\": \"Question text here\",\n");
        prompt.append("      \"options\": [\"Option A\", \"Option B\", \"Option C\", \"Option D\"],\n");
        prompt.append("      \"correctAnswerIndex\": 0,\n");
        prompt.append("      \"explanation\": \"Explanation for the correct answer\"\n");
        prompt.append("    }\n");
        prompt.append("  ]\n");
        prompt.append("}\n\n");
        prompt.append("Requirements:\n");
        prompt.append("- Questions must be directly related to the lesson content\n");
        prompt.append("- Each question should have exactly 4 options\n");
        prompt.append("- Only one correct answer per question\n");
        prompt.append("- Provide clear explanations for correct answers\n");
        prompt.append("- Use appropriate language level for the grade\n");
        prompt.append("- Return only valid JSON format\n");
        
        return prompt.toString();
    }
    
    private String buildChatPrompt(String message, String context) {
        StringBuilder prompt = new StringBuilder();
        prompt.append("You are an AI assistant helping teachers create and refine educational questions.\n");
        prompt.append("Context: ").append(context).append("\n\n");
        prompt.append("Teacher's message: ").append(message).append("\n\n");
        prompt.append("Please provide a helpful response to assist the teacher in improving their questions.");
        return prompt.toString();
    }
    
    private String callGeminiAPI(String prompt) throws Exception {
        URL url = new URL(GEMINI_API_URL + "?key=" + GEMINI_API_KEY);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);
        
        // Build request body
        JsonObject requestBody = new JsonObject();
        JsonArray contents = new JsonArray();
        JsonObject contentObj = new JsonObject();
        JsonArray parts = new JsonArray();
        JsonObject part = new JsonObject();
        part.addProperty("text", prompt);
        parts.add(part);
        contentObj.add("parts", parts);
        contents.add(contentObj);
        requestBody.add("contents", contents);
        
        // Send request
        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = requestBody.toString().getBytes("utf-8");
            os.write(input, 0, input.length);
        }
        
        // Read response
        int responseCode = conn.getResponseCode();
        if (responseCode != 200) {
            throw new Exception("Gemini API call failed with response code: " + responseCode);
        }
        
        try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"))) {
            StringBuilder response = new StringBuilder();
            String responseLine;
            while ((responseLine = br.readLine()) != null) {
                response.append(responseLine.trim());
            }
            
            // Parse response to extract text content
            JsonParser parser = new JsonParser();
            JsonObject responseJson = parser.parse(response.toString()).getAsJsonObject();
            JsonArray candidates = responseJson.getAsJsonArray("candidates");
            if (candidates.size() > 0) {
                JsonObject candidate = candidates.get(0).getAsJsonObject();
                JsonObject responseContent = candidate.getAsJsonObject("content");
                JsonArray responseParts = responseContent.getAsJsonArray("parts");
                if (responseParts.size() > 0) {
                    return responseParts.get(0).getAsJsonObject().get("text").getAsString();
                }
            }
            
            throw new Exception("No content found in Gemini response");
        }
    }
    
    private List<AIQuestion> parseQuestionsFromResponse(String response) throws Exception {
        List<AIQuestion> questions = new ArrayList<>();
        
        try {
            // Extract JSON from response if it contains other text
            String jsonContent = extractJsonFromResponse(response);
            JsonParser parser = new JsonParser();
            JsonObject jsonResponse = parser.parse(jsonContent).getAsJsonObject();
            JsonArray questionsArray = jsonResponse.getAsJsonArray("questions");
            
            for (int i = 0; i < questionsArray.size(); i++) {
                JsonObject questionObj = questionsArray.get(i).getAsJsonObject();
                AIQuestion question = new AIQuestion();
                
                question.setQuestion(questionObj.get("question").getAsString());
                question.setCorrectAnswerIndex(questionObj.get("correctAnswerIndex").getAsInt());
                question.setExplanation(questionObj.get("explanation").getAsString());
                
                JsonArray optionsArray = questionObj.getAsJsonArray("options");
                List<String> options = new ArrayList<>();
                for (int j = 0; j < optionsArray.size(); j++) {
                    options.add(optionsArray.get(j).getAsString());
                }
                question.setOptions(options);
                
                questions.add(question);
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Failed to parse AI response: " + response, e);
            throw new Exception("Failed to parse AI generated questions: " + e.getMessage());
        }
        
        return questions;
    }
    
    private String extractJsonFromResponse(String response) {
        // Find JSON content between { and }
        int startIndex = response.indexOf("{");
        int endIndex = response.lastIndexOf("}");
        
        if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
            return response.substring(startIndex, endIndex + 1);
        }
        
        return response; // Return as is if no JSON markers found
    }
}