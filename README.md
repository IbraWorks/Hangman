Pre thoughts
---------------------
Hangman is a much easier game for me to code for (probably because I've heard
of it lol) than mastermind. So the game itself shouldnt be too difficult.
But this is my first time with serialization, and I'm really excited to be able
to create something that can save and load files.

Things I'm concerned about:
1) The serialization. It's still all new to me.

Things I'm confident in:
1) This is my third oop project now so I'm quite used to it all. The game should
(hopefully) take little time to build.

Post thoughts
---------------------
As I suspected the game itself wasnt that difficult.
After completing the game, to test myself, I didn't just load the dictionary in
but allow for the user to dictate how short they want to the shortest word to be
and how long they want the longest word to be. My plan was to then have a function
that checks how short the shortest word is in the dictionary.txt file and how long
the longest word is, and then to ensure that the user does not select a word
that is too short or too long (i.e. a word that doesnt exist in the dictionary).
Unfortunately I haven't got round to doing this just yet (though I've left the
methods in the board.rb file for reference).

Also, the game is set up kind of awkwardly when it comes to loading games.
It asks you for your longest/shortest word and then asks if you want to load any
previous game. If you say yes to the latter question it makes the previous question
pointless. I should refactor this once I have time. But for now, I'm proud of
this project and eagerly anticipating what's coming up next in The Odin Project!

Things I need to improve on:
1) Take user experience into consideration
