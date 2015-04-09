## Auriel's notes 

today we are going to learn about data management and plotting, specifically plotting in ggplot2 (often just called ggplot). 

Good data management and being able to manipulate your data is key to being able to graph with ease, and do most things in R. 

So first lets dive into tidying data. 

first we are going to cover data management, one, because you should manage your data before you do anything else, and two, because if you don't, ggplot won't talk to you.

for both data management and plotting there is a learning curve, I sucked at this first, you might as well, its part of the process. 


> So what do we mean by 'tidy' data?

data that is clear, and does what you think it does. 
this also means data taht is well arranged, and in a format where R can understand what the data is and use it effectively
it means getting rid of spaces, blanks and other things that cloud your data
and documenting it well

Yourself 6 months ago is your main collaborator, and you can't send that person an email, so document everything that you do!

The data I've given you today is a bit messy, but is not even close to the messiest data I've ever seen. 

We are going to 'clean up' a few common things in messy data and then work on manipulating the data a little bit. 

## blanks - we hate them!
## dashes - we hate them!
## other weird things taht indicate missing data, we hate them!
## NA - we love them!

