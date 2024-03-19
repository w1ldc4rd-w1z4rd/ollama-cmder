# Ollama Commander

### Enhanced Interaction with `oc.pl` using the Ollama API

This section of the guide focuses on how you can use `oc.pl` to generate text responses from either local files or web content, utilizing the capabilities of the Ollama API. 

### Before You Start

Make sure Perl is installed on your computer along with these modules: `Term::ANSIColor`, `LWP::UserAgent`, `HTTP::Request`, `JSON::XS`, `Data::Dumper`, and `Encode`. These modules are essential for web requests, JSON handling, and managing encoding operations within the script.

### Running the Script

1. **For File-based Input**: To generate text using content from files, execute the script with the file paths as arguments:
   ```bash
   perl oc.pl myfile.txt anotherfile.txt
   ```
   The script processes the text from the specified files for your input.

2. **For URL-based Input**: To use text from a webpage, employ the `-url` option like so:
   ```bash
   perl oc.pl -url='http://example.com'
   ```
   This instructs the script to fetch and process the webpage's text content.

3. **Simplifying Output with `-hide`**: Opt for the `-hide` flag if you wish to view only the AI-generated response, omitting extra information:
   ```bash
   perl oc.pl -hide -url='http://example.com'
   ```

### Providing Prompts via Standard Input (Stdin)

The script supports receiving custom prompts through stdin, which allows you to guide the AI's response generation based on your specific needs or questions. Here's an illustrative example using a pipe:

```bash
echo "Please summarize the main points." | perl oc.pl myfile.txt
```

In this example, the prompt "Please summarize the main points." is directly fed to `oc.pl` which then processes `myfile.txt` in conjunction with this prompt to generate a response from the Ollama API.

### What the Script Does

- **Text Acquisition**: `oc.pl` retrieves text from either the files or URL you specify.
- **Custom Prompting**: Beyond automatic prompt generation from the processed text, you can directly input your custom prompt via stdin. This can be bypassed with the `-hide` option.
- **Ollama API Interaction**: After formatting the input text and any custom prompts, the script communicates with the Ollama API for response generation.
- **Output Presentation**: The response from the Ollama API is displayed in your terminal. Without the `-hide` flag, additional process details are also shown.

### Tips and Tricks

- **Focus on Results**: Use `-hide` to concentrate on the API's response, ideal for when you need clarity and brevity.
- **Reliability and Error Checking**: The script includes safeguards against common issues such as file access or web request errors, ensuring smooth operation.
