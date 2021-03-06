module Common::WordCount

// wordCount takes a list of strings and a count function
// that is applied to each line. The total number of words is returned
public int wordCount(list[str] input, int (str s) countInLine)
{
	count = 0;
	for(str line <- input)
	{
		count += countInLine(line);
	}
	return count;
}

public int countInLine1(str S)
{
	int count = 0;
	for(/[a-zA-Z0-9_]+/ := S)
	{
		count += 1;
	}
	return count;
}

public int countInLine2(str S)
{
	int count = 0;
  
	// The ^ makes it anchored, only matches at the begin of the substring S.
	// \W* matches zero or more non-word characters.
	// <word:\w+> matches one or more word characters and assigns the result to the variable word.
	// <rest:.*$> matches the remaining part of S.
	while (/^\W*<word:\w+><rest:.*$>/ := S)
	{
		count += 1;
		S = rest;
	}
	return count;
}

public int countInLine3(str S)
{
	//0 is the initial value of the reducer
	//The pattern match /\w+/ := S matches all words in S.
	//Reduction is done by it + 1. 'it' is a keyword that refers to the value that
	//has been reduced so far. Effectively, the matches are reduced to a match count.
	return (0 | it + 1 | /\w+/ := S);
}

public list[str] jabberwockey = [
	"Jabberwocky by Lewis Carroll",
	"",
	"\'Twas brillig, and the slithy toves",
	"Did gyre and gimble in the wabe;",
	"All mimsy were the borogoves,",
	"And the mome raths outgrabe.",
	"",
	"\"Beware the Jabberwock, my son!",
	"The jaws that bite, the claws that catch!",
	"Beware the Jubjub bird, and shun",
	"The frumious Bandersnatch!\"",
	"",
	"\'Twas brillig, and the slithy toves",
	"Did gyre and gimble in the wabe;",
	"All mimsy were the borogoves,",
	"And the mome raths outgrabe.",
	"",
	"\"Beware the Jabberwock, my son!",
	"The jaws that bite, the claws that catch!",
	"Beware the Jubjub bird, and shun",
	"The frumious Bandersnatch!\"",
	"",
	"He took his vorpal sword in hand:",
	"Long time the manxome foe he sought—",
	"So rested he by the Tumtum tree,",
	"And stood awhile in thought.",
	"",
	"And as in uffish thought he stood,",
	"The Jabberwock, with eyes of flame,",
	"Came whiffling through the tulgey wood",
	"And burbled as it came!",
	"",
	"One, two! One, two! and through and through",
	"The vorpal blade went snicker-snack!",
	"He left it dead, and with its head",
	"He went galumphing back.",
	"",
	"\"And hast thou slain the Jabberwock?",
	"Come to my arms, my beamish boy!",
	"O frabjous day! Callooh! Callay!",
	"He chortled in his joy.",
	"",
	"\'Twas brillig, and the slithy toves",
	"Did gyre and gimble in the wabe;",
	"All mimsy were the borogoves,",
	"And the mome raths outgrabe."
];