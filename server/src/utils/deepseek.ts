import axios from 'axios';
import { config } from '../config';

interface Message {
  role: 'user' | 'assistant';
  content: string;
}

export async function chatWithDeepSeek(messages: Message[]): Promise<string> {
  try {
    const response = await axios.post(
      config.deepseek.apiUrl,
      {
        model: config.deepseek.model,
        messages,
        temperature: 0.7
      },
      {
        headers: {
          'Authorization': `Bearer ${config.deepseek.apiKey}`,
          'Content-Type': 'application/json'
        }
      }
    );

    return response.data.choices[0].message.content;
  } catch (error) {
    console.error('DeepSeek API error:', error);
    throw new Error('AI chat failed');
  }
}
