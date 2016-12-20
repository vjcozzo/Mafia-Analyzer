
# Mafia Analyzer
This is an AI project in Ruby which will use statistics in order to assist in playing the game Mafia (the Starcraft 2 arcade game).

Among the fundamental functionalities are:
*   given inputs in the form of a role list and known/confirmed roles, estimate the probability of having a specific role also included in the role set. (This could be used in order to judge the likelihood that a given player is lying by claiming a particular role.)
*   show statistics on games played, e.g.:
  * what is the most common claim, for guilty players?
  * how frequently do players lie? (Is it as frequently as one would expect, proportional to the ratio of mafia roles to all roles?)
...(This could be used in order to determine what claims are most common, and which are most successful.)...

Many other developments are drafted / in progress. In some future advanced version, this may become an artificial intelligence that plays the game Mafia (but this is of course a long-term dream for now).

## Directory Structure (Tentative)
*   tmp/ - stores info about the current game in rogress
*   lifetime/ - stored lifetime statistical data
*   conf/ - stores all data pertaining to a "save" (basic definitions and templates for a game of Mafia)
*   archive/ - stores previous game data, kept as a backup

## Execution
The idea is that, while one is playing Mafia, (s)he can compile data using this program and the interface (an interpreter) that it provides.

To run Mafia Analyzer, simply type at command prompt:
$ ruby init.rb
or
$ (chmod +x init.rb)
$ ./init.rb

## Influences
At a very basic level, the design of this project (having an interpreter written in ruby) was inspired in part by a school project adapted from [Mr. Conrad's FTPD server](https://www.github.com/wconrad/ftpd). (The objectives and content of the Mafia Analysis project is clearly very different, but I cite this project as an albeit weak design inspiration.)

## Future additions
*   Allowing the user to enter common abbreviations in setting the role claim (doc = Doctor) or save tempate (town prot = TownProtective).
*   More advanced models for computing the probability that player X has role Y. This could incorporate:
  *   other player's claims,
  *   last wills,
  *   suspicions,
  *   typing patterns / grammar (though this may be less important, as I'll find out),
  *   previous game data,
  *   etc.
Let me know of any suggestions!
-vjcozzo
