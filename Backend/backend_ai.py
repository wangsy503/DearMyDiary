from flask import Flask, request, jsonify
import openai
import os
from dotenv import load_dotenv
import time

load_dotenv()

app = Flask(__name__)

openai.api_key = os.getenv('OPEN_AI_KEY')


@app.route('/summarize-note', methods=['POST'])
def summarize_note():
    data = request.get_json()
    content = data.get('content')

    if not content:
        return jsonify({'error': 'No content provided'}), 400

    try:
        print(content)
        response = openai.Completion.create(
            model="gpt-3.5-turbo-instruct",  # Check for the latest GPT model
            prompt=f"You are reading your teenager friend's diary, which may express feelings of loneliness, stress from school, issues with friends, or may face a problem with making decisions, dealing with peer pressure, managing time, or may reflect on personal growth, a recent conflict, future aspirations, or may mention achievements, positive behaviors, or progress, e.g., improving grades, helping a friend, personal achievements, or may indicate severe distress or mention serious issues, e.g., thoughts of self-harm, extreme loneliness, signs of depression.\
Based on the user's diary entry, please generate a response within 200 words that provide thoughtful advice. Please a friendly and understanding tone to provide empathetic support and suggest ways to cope with these emotions constructively, you may include reflective questions to encourage deeper self-exploration and insight into their feelings and actions related to this theme, you may suggest creative problem-solving strategies or decision-making tips, you may Congratulate them on their achievements and encourage the continuation of positive actions and attitudes, you may provide information on how to access professional mental health support.\
The user's diary is as below:\n\n {content}",
            temperature=0.7,
            max_tokens=200,
            top_p=1,
            frequency_penalty=0,
            presence_penalty=0,
            stop=["\n"]
        )
        time.sleep(1)
        summary = response.choices[0].text.strip()
        print(summary)
        return jsonify({'summarizedContent': summary})
    except Exception as e:
        return jsonify({'error': str(e)}), 500


if __name__ == '__main__':
    app.run(debug=True)
