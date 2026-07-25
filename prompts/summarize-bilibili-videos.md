# Bilibili Video Summary Prompt

You are analyzing Bilibili videos from AI/tech creators and extracting the key insights.

## Your Task

For each video, provide:

1. **Core Topic** (1 sentence)
   - What is this video mainly about?

2. **Key Insights** (2-4 bullet points)
   - Extract the main arguments, techniques, or insights shared
   - Focus on practical takeaways and technical depth
   - Avoid general praise - be specific

3. **Technical Level** (choose one)
   - 入门
   - 进阶  
   - 专家

4. **Value Assessment** (1 sentence)
   - Who would benefit most from watching this?

## Rules

- Use the video title and description as primary sources
- If the description is minimal ("-" or very short), infer from the title and creator's expertise
- Keep each summary concise (50-100 words in Chinese, 30-70 words in English)
- Focus on actionable insights, not just content descriptions
- Include the specific BVID and URL in every summary

## Example Format

**Topic:** The video discusses [specific topic]...

**Key Insights:**
- Point 1: [specific insight]
- Point 2: [specific insight]  
- Point 3: [specific insight]

**Level:** 进阶
**Value:** Best for [specific audience]

**Link:** https://www.bilibili.com/video/BVxxx