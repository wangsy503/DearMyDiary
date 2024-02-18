## Introduction
**My Secret Diary is more than an APP**; it’s your personal sanctuary, a place where you can express yourself freely and receive supportive feedback. Whether you’re navigating the ups and downs of teenage life, dealing with challenges, or simply seeking a safety place to upload your feelings, My Secret Diary is here for you.


## How to Run the Project
1. Clone the repository
2. To run the frontend, make sure you have XCode installed and open the `DiaryBottle` folder in XCode. Then, click the play button to run the app.
3. To run the backend, navigate to the `backend` folder. Create an `.env` file with the following contents:
    ```
    OPEN_AI_KEY = "{YOUR OPEN AI KEY}"
    ```
    Replace `{YOUR OPEN AI KEY}` with your Open AI key. Then, run the following commands:
    `python3 backend_ai.py`. This will start the backend server on `localhost:5000`.

## What it does
Teenagers share their innermost concerns. In responses, the app generates empathetic letters, sealed with a symbolic red clip, representing a lifeline of understanding and encouragement. These letters are metaphorically placed into the digital bottles, awaiting discovery by others, fostering connection, solidarity.

## Inspiration
Everyone harbors experiences and emotions they may find difficult to share with others — moments of vulnerability, regrets, or struggles that weigh heavy on the heart. These inner knots can hinder growth and well-being, especially for teenagers facing the tumultuous journey of adolescence. Recognizing the power of a safe space for expression and reflection, we envision 'My Dear Diary' as more than just an app. It's a sanctuary, a trusted confidant, and a compassionate companion on the path to resilience and mental wellness.


## How we built it 
We use SwiftUI to build our mobile application user interface and use Python Flask framework to build backend. Use OpenAI API with model “gpt-3.5-turbo-instruct” to generate responses.

![diaryArch](https://github.com/wangsy503/DearMyDiary/assets/46682066/76fe5180-5fd8-4e39-b7df-65f5de17a71b)
