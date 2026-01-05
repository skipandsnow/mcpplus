package com.example.mcpserver.config;

import com.example.mcpserver.tools.CalculatorTool;
import com.example.mcpserver.tools.SystemInfoTool;
import org.springframework.ai.tool.ToolCallbackProvider;
import org.springframework.ai.tool.method.MethodToolCallbackProvider;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class McpToolConfig {

    @Bean
    public ToolCallbackProvider calculatorTools(CalculatorTool calculatorTool) {
        return MethodToolCallbackProvider.builder()
                .toolObjects(calculatorTool)
                .build();
    }

    @Bean
    public ToolCallbackProvider systemInfoTools(SystemInfoTool systemInfoTool) {
        return MethodToolCallbackProvider.builder()
                .toolObjects(systemInfoTool)
                .build();
    }
}
