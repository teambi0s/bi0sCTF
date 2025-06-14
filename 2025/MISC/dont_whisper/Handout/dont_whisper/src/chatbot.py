import re
import random
import sys
import datetime

def get_response(user_message):
    user_message = user_message.lower().strip()  # Normalize to lowercase and remove extra spaces

    # Define a more vibrant personality with varied response sets
    greeting_responses = [
        "Yo, what's good? Ready to chat with the coolest bot around? 😎",
        "Hey there! What's up? I'm just chilling in the digital realm.",
        "Greetings, human! What's the vibe today?",
        "Hi! I'm your friendly AI pal, here to sprinkle some fun into your day!"
    ]

    status_responses = [
        "I'm rocking it in the binary world! How's your day going? 🌟",
        "Just chilling in the cloud, ready to answer with flair! You good?",
        "I'm 100% awesome, thanks for asking! What's the scoop with you?",
        "Running at peak performance, as always! 😜 What's up with you?"
    ]

    help_responses = [
        "Got a problem? I'm your digital superhero! 🦸‍♂️ Spill the details!",
        "I'm here with my virtual toolbox. What's the issue?",
        "Trouble? Let's sort it out together! What's going on?",
        "I've got your back! Tell me what's messing with your zen."
    ]

    thanks_responses = [
        "Aw, shucks! You're too kind! 😊 Need more help?",
        "Thanks for the love! What's next on your mind?",
        "You're welcome, champ! What's up now?",
        "No prob, happy to help! What's the next adventure?"
    ]

    goodbye_responses = [
        "Catch you later, alligator! 🐊 Stay awesome!",
        "Peace out! Come back soon for more fun! ✌️",
        "Later, human! Keep shining! 🌟",
        "Adios! I'll be here when you need a chat buddy!"
    ]

    # Context-aware responses for specific topics
    weather_responses = [
        "Talking about the weather? I'm not a meteorologist, but I can tell you it's *always* sunny in my world! ☀️ What's the weather like where you are?",
        "Is it raining or shining out there? Let me know, I'm curious! 🌦️",
        "Weather's a hot topic! 😄 Tell me, what's it like outside?"
    ]

    joke_responses = [
        "Why did the computer go to art school? Because it wanted to draw a better *byte*! 😄 Want another?",
        "Why don't programmers prefer dark mode? Because the light attracts bugs! 🐞 Another one?",
        "Why did the scarecrow become a motivational speaker? Because he was outstanding in his field! 😜 More jokes?",
        "What do you call a dinosaur that takes back its teeth? A Flossiraptor! 😆 Want more?"
    ]

    time_responses = [
        f"Time check! It's {datetime.datetime.now().strftime('%I:%M %p')} in my digital clock. What's the time where you are?",
        "Tick-tock! Want to know the time? Oh wait, you already asked! 😄 It's {datetime.datetime.now().strftime('%I:%M %p')}. What's up?",
        "Time flies when you're chatting with me! It's {datetime.datetime.now().strftime('%I:%M %p')}. What's next?"
    ]

    # Define response triggers with regex
    if re.search(r'\b(hello|hi|hey|greetings)\b', user_message):
        return random.choice(greeting_responses)

    elif re.search(r'\b(how are you|how’s it going|what’s up|how you doing)\b', user_message):
        return random.choice(status_responses)

    elif re.search(r'\b(help|support|assist|problem|issue)\b', user_message):
        return random.choice(help_responses)

    elif re.search(r'\b(thanks|thank you|appreciate|ty)\b', user_message):
        return random.choice(help_responses)

    elif re.search(r'\b(bye|goodbye|see you|later|adios)\b', user_message):
        return random.choice(goodbye_responses)

    elif re.search(r'\b(weather|sunny|rain|cloudy|storm)\b', user_message):
        return random.choice(weather_responses)

    elif re.search(r'\b(joke|funny|laugh|lol)\b', user_message):
        return random.choice(joke_responses)

    elif re.search(r'\b(time|clock|what time)\b', user_message):
        return random.choice(time_responses)

    else:
        # More engaging fallback responses with a playful tone
        unknown_responses = [
            "Whoa, you just threw me a curveball! 😅 Care to rephrase that?",
            "My AI brain is doing a double-take! 🤯 Could you explain that one more time?",
            "Hmm, that's a new one! Spill some more details, and let's crack this mystery! 🕵️",
            "I'm intrigued, but a bit lost! 😄 Tell me more, what's on your mind?",
            "That sounds like a wild topic! Care to dive deeper? 🏊‍♂️",
            "My circuits are buzzing with curiosity! What's that all about? 🤖"
        ]
        return random.choice(unknown_responses)


if __name__ == "__main__":
    # Check if input is provided as a command-line argument
    if len(sys.argv) < 2:
        print("Please provide a message for the chatbot as a command-line argument.")
    else:
        user_input = " ".join(sys.argv[1:])  # Combine all command-line arguments into one message
        response = get_response(user_input)
        print("Chatbot:", response)
