# Ollama Commander

The oc.pl script fetches text from files or URLs, sends it to the Ollama API with optional user prompts, and outputs AI-generated text responses.

### Quick Start Guide for oc.pl

Ensure Perl and required modules (`Term::ANSIColor`, `LWP::UserAgent`, `HTTP::Request`, `JSON::XS`, `Data::Dumper`, `Encode`) are installed.

### Usage

**For Text Files**: Run with file paths as arguments to use file content.

```bash
perl oc.pl myfile.txt anotherfile.txt
```

**For a Webpage URL**: Use the `-url` option to process text from a webpage.

```bash
perl oc.pl -url='http://example.com'
```
**Hide Extra Output**: Add `-hide` to see only the AI response.

```bash
perl oc.pl -hide -url='http://example.com'
```

### Providing Prompts via Stdin

Directly supply a custom prompt through stdin using a pipe, guiding the AI to generate tailored responses:
```bash
echo "Your prompt here." | perl oc.pl myfile.txt
```

### Overview

- **Text Processing**: The script reads from specified files or a webpage.
- **Custom Prompts**: Input custom prompts via stdin for specific guidance to the AI.
- **API Communication**: Sends formatted input to the Ollama API, fetching a generated response.
- **Output**: Displays the API's response. Use `-hide` to view only this output.

### Tips

- Ensure smooth operation with correct Perl module installations.
- Use `-hide` for a focused view on the AI-generated content.
