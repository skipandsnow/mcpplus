package com.example.mcpserver.tools;

import org.springframework.ai.tool.annotation.Tool;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Map;

@Service
public class SystemInfoTool {

    @Tool(description = "Get the current date and time")
    public String getCurrentTime() {
        return LocalDateTime.now()
                .format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
    }

    @Tool(description = "Get basic system information")
    public Map<String, String> getSystemInfo() {
        return Map.of(
                "os.name", System.getProperty("os.name"),
                "os.version", System.getProperty("os.version"),
                "java.version", System.getProperty("java.version"),
                "user.name", System.getProperty("user.name"));
    }
}
