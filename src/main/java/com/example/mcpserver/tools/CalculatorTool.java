package com.example.mcpserver.tools;

import org.springframework.ai.tool.annotation.Tool;
import org.springframework.ai.tool.annotation.ToolParam;
import org.springframework.stereotype.Service;

@Service
public class CalculatorTool {

    @Tool(description = "Add two numbers together")
    public double add(
            @ToolParam(description = "First number") double a,
            @ToolParam(description = "Second number") double b) {
        return a + b;
    }

    @Tool(description = "Subtract second number from first")
    public double subtract(
            @ToolParam(description = "First number") double a,
            @ToolParam(description = "Second number") double b) {
        return a - b;
    }

    @Tool(description = "Multiply two numbers")
    public double multiply(
            @ToolParam(description = "First number") double a,
            @ToolParam(description = "Second number") double b) {
        return a * b;
    }

    @Tool(description = "Divide first number by second")
    public double divide(
            @ToolParam(description = "Dividend") double a,
            @ToolParam(description = "Divisor (non-zero)") double b) {
        if (b == 0) {
            throw new IllegalArgumentException("Cannot divide by zero");
        }
        return a / b;
    }
}
