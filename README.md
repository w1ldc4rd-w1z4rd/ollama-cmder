# Ollama Commander

The oc.pl script fetches text from files or URLs, sends it to the Ollama API with optional user prompts, and outputs AI-generated text responses.

### Script Features Explained

- **Input Flexibility**: Use text from local files or fetch content from the web `-url=''`.
- **Output Control**: The `-hide` option streamlines the output to just the AI's response.
- **Custom Prompts**: With `-freestyle`, input any prompt directly for tailored AI responses.
- **Professional Rewriting**: The `-rewrite` feature refines text to a business professional tone.

### Using `oc.pl` Script: A Guide with Code Examples

The `oc.pl` script enables processing text from files or URLs for AI-generated content creation. It supports various modes for different requirements, such as direct response generation and text rewriting.

### Setup

Make sure Perl is installed with these modules: `Term::ANSIColor`, `LWP::UserAgent`, `HTTP::Request`, `JSON::XS`, `Data::Dumper`, `Encode`.

### How to Use

1. **Standard Mode**
   - **URL Fetch**: 
     ```bash
     perl oc.pl -url='http://example.com'
     ```
   - **File Input**: 
     ```bash
     perl oc.pl myfile.txt
     ```

2. **Hide Mode** (`-hide`)
   - Hides everything but the AI response.
     ```bash
     perl oc.pl -hide -url='http://example.com'
     ```

3. **Freestyle Mode** (`-freestyle`)
   - Allows for a custom prompt. Here's how to use it with echo and a pipe for input:
     ```bash
     echo "Describe the impact of global warming." | perl oc.pl -freestyle
     ```

4. **Rewrite Mode** (`-rewrite`)
   - For rewriting text in a business professional manner:
     ```bash
     perl oc.pl -rewrite file.txt
     ```
