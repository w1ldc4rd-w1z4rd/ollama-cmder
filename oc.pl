#!/usr/bin/perl -s

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ INFO
#
# by: w1ldc4rd-w1z4rd
#
#  usage:
#  perl oc.pl -hide      ~> hide everything but response
#  perl oc.pl -url='URL' ~> crawl url
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PRAGMAS 

use Term::ANSIColor qw(:constants);
use feature q|say|;
use LWP::UserAgent;
use HTTP::Request;
use JSON::XS;
use warnings;
use Data::Dumper;

use utf8; 
# UTF-8 encoding for standard input/output
use open ':std', ':encoding(UTF-8)'; 
# alternative way to do the same as above
use open ':encoding(UTF-8)', ':std'; 
use Encode qw(decode);

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ GLOBALS

# $url # -url
# $hide # -hide

$|++;

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ DISPATCH TABLE

my $dt = 
{
	# none ~> text, owc
	txt => \&txt_ingest,
	# text ~> ask
	prompt => \&prompt_me,
	# owc, text, ask ~> text
	tokenizer => \&tokenizer,
	# text ~> payload
	llm => \&llm_config,
	# payload, url ~> STDOUT    	
	ai => \&ai_api,
	url => sub { return q|http://localhost:11434/api/generate| },
};

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ INIT
  
my ( $text, $org_word_count ) = $dt->{txt}();

$dt->{ai}( 
	$dt->{llm}( 
		$dt->{tokenizer}( $org_word_count, $text, $dt->{prompt}( $text ) ) 
	)->(), $dt->{url}() );

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ SUB - LLM CONFIG

sub llm_config()
{
	my $text = shift;
		
	my $config =
	{
		model   => "mistral", 
		prompt  => "${text}",
		options =>  { num_ctx => 16384 }
	};
	
	# 16384
	# 8192
		
	return sub { return $config };
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ SUB - FILE INGEST

sub txt_ingest()
{
	my $text = '';
	
	if ($url)
	{  	
		no warnings 'utf8';		
		$text = decode ( 'UTF-8', qx|lynx -dump -nolist '$url'| ); 
	}
	elsif (@ARGV)
	{
		
		map
		{
			chomp;
	
			if (-f $_ and -T $_)
			{
				open my $fh, '<', $_ or do
				{
					say RED BOLD qq|> can't open file <$_>...|, RESET; #'
					exit 1;
				};
	
				while (my $line = <$fh>)
				{
					$text .= $line;
				}
			}
	
		} @ARGV;
		
	}
	
	my $words = scalar ( split( m~\s+~, $text ) );
		
	return ($text, $words);
	
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ SUB - PROMPT

sub prompt_me()
{
	my $text = shift;
	my $ask;
	
	unless ($hide || !$text)
	{
		print YELLOW BOLD q|> prompt: |, RESET;	
	}
	
	$ask = <STDIN> if ($text or $url);
	 
	if ($ask)
	{
		say '' unless $ask =~ m~^\n$~;
		chomp $ask;
	}
	
	no warnings;
	$ask = sprintf qq|\n%s\n%s%s\n%s|
	, q|-|x80
	, ($url ? q|Referencing the website mentioned above, | : '' ) 
	. (($url and $text) ? q|b| : q|B| )
	. ($text ? q|ased on the text provided, | : '') 
	. q|generate a brief and precise response in bullet points, ensuring no critical information is omitted: |
	, $ask ? $ask : q|Please summarize.|, q|-|x80;
	
	return $ask;
};

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ SUB - TOKENIZER  

sub tokenizer()
{
	my $word_count = shift;
	my $text  = shift;
	my $ask   = shift;
	
	if ($text)
	{
	
		chomp ( $text );
		$text = reverse $text;	
		my $c = 0;
		
		my $re_tok = qr~(?x)
		
			(?:
				([[:space:]]+)?[[:alnum:]]+(?1)?
				|
				(?1)?[[:punct:]]+(?1)?
				|
				(?1)?\p{Any}(?1)?
				
			){1,9000}~;
		
		if ($text =~ m~^${re_tok}~)
		{
			$text = $&;
		}	
	
		$text = reverse $text;
		
		no warnings;
		if ($word_count > 0 and !$hide)
		{
			my $re_nl = qr|[^\n\r\x{0B}\x{0C}\x{85}\x{2028}\x{2029}]|;
			
			# printf qq|TEXT:\n%s\n%s\n%s\n|, q|-|x80, $text, q|-|x80; # debug
			
			printf qq|BEGIN   : %s\n|, ( $text =~ s~^(${re_nl}{1,150}).*~$1~sr  ) =~ s~\ +~ ~rg; 
			printf qq|END     : %s\n|, ( $text =~ s~.*?(${re_nl}{1,150})$~$1~sr ) =~ s~\ +~ ~rg;
			
			my $trim_count = scalar(split(m~\s+~, $text));
					
			printf qq|TRIMMED : %s\n|, $trim_count unless $trim_count ==  $word_count;	
			printf qq|WORDS   : %s|, $word_count;
		}
		
		say $ask unless $hide; 
		
		$text .= $ask;
		
		$text =~ s~\x{27}~\x{2018}~g;
		$text =~ s~\x{22}~\x{201F}~g;
		
		return $text;
	}
	else
	{
		return $ask;	
	}
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ SUB - AI API

sub ai_api()
{
	my $payload = shift;
	my $url = shift;
	
	# say Dumper $payload; # debug
	
	my $json = JSON::XS->new->utf8;	
	my $ua   = LWP::UserAgent->new;
	
	$ua->timeout(300);
	
	# convert hash reference to JSON
	my $json_data = encode_json($payload);
	
	# create HTTP POST request
	my $request = HTTP::Request->new(POST => $url);
	$request->content_type('application/json');
	$request->content($json_data);
	
	# send the request and process the response content as it's received
	my $response = $ua->request($request, sub 
	{
	    my ($chunk, $res) = @_;
	    my $response = $json->decode($chunk);
	    
	    if ($hide)
	    {
	    	print $response->{response};
	    }
	    else
	    {
	    	print BOLD GREEN $response->{response}; 	   
	    }
	       
	});
	
	# check the final response
	if ($response->is_success) 
	{
	    print BOLD BLUE "\n> request completed successfully.\n", RESET unless $hide;
	    exit 0;
	} 
	else 
	{
	    die RED BOLD "> request failed: " . $response->status_line . "\n", RESET;
	}
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ EXIT

__END__
