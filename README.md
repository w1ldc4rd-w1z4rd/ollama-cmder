# Ollama Commander

### Command Line AI

1. **Prerequisites:** Required modules such as `Term::ANSIColor`, `LWP::UserAgent`, `HTTP::Request`, `JSON::XS`, and `Data::Dumper` 

2. **Input:** The script accepts input from the command-line arguments, a file, or a URL. You can either provide a text file containing the text you want to summarize as an argument or pass a URL to fetch content from a website. If no input is provided, it will read from STDIN.

3. **Interactive Prompt:** The script uses the `prompt_me()` function to ask for a summary prompt if needed. You can hide this step by setting the environment variable `--hide` to true before running the script.

4. **Tokenization:** The `tokenizer()` function tokenizes the input text based on space, punctuation, and other characters. It also trims extra spaces and checks the word count against the expected word count.

5. **LLM Configuration:** This step is used to configure the Language Model for Large Texts (LLM) using a configuration hash. The default configuration uses the Mistral model, but you can change it as needed.

6. **API Call:** The `ai_api()` function sends a summary request to the AI API with the provided payload and URL. It also handles the response from the API and outputs it if not hiding output.

7. **Run the Script:** Run by providing the required input or arguments as mentioned above. For example: `perl clai.pl <input_file>` or `perl clai.pl --url=<website_url>`.

Keep in mind that you may need to adjust certain aspects of the script based on your specific use case, such as input handling, summary length, or API configuration.  I intend on improving this as time goes on.
