# Quiz Overview
This is a short quiz consisting of 6 multiple choice questions and 2 short answer questions. This covers our discussion of ssh and our introductory discussion of the Angband project. 

You can take the quiz anytime up until the due date and time. Once you begin the quiz you will have only 15 minutes to complete the quiz. 

This like all quizzes in the class is an individual activity.

Question 1-6 are worth 1 point each. Question 7 & 8 are worth 2 pts each. 


# Question 1
Which statements are true of symmetric encryption? (Select all that are true.)
## correct answers
- Symmetric encryption algorithms are very fast and faster than asymmetric encryption.
- The same key is used for encryption as decryption.

## incorrect options
- Uses a pair of keys such that if an item is encrypted with one key it can only be decrypted with the other key.
- Used by ssh to authenticate logins

# Question 2
Which statements are true of asymmetric encryption? (Select all that are true.)

## correct options
- Uses a pair of keys such that if an item is encrypted with one key it can only be decrypted with the other key.
- Used by ssh to authenticate logins.
- Symmetric encryption algorithms are very fast and faster than asymmetric encryption

## incorrect options
- The same key is used for encryption as decryption.

# Question 3
In which file do you place an ssh public key to enable ssh authentication to a remote system?  

remote - refers to the remote system 

localhost - refers to your local machine, e.g. your laptop
## correct options
- remote:$HOME/.ssh/authorized_keys 

## incorrect options
- localhost:$HOME/.ssh/authorized_keys
- remote:$HOME/.ssh/known_hosts
- localhost:$HOME/.ssh/known_hosts

# Question 4
Which key does ssh use to verify the remote system identity when authenticating a remote login?

## correct options
-  Uses the remote host public key stored in localhost:$HOME/.ssh/known_hosts

## incorrect options
-  ssh does not verify the identify of remote systems
- Uses the user’s public key stored in localhost:$HOME/.ssh
- Uses the remote host public key stored in remote:$HOME/.ssh/known_hosts

# Question 5
What is the ssh-agent?

## correct options
- A daemon or service running on the localhost that provides unencrypted private keys to ssh commands.
## incorrect options
-  A daemon or service running on the remote system that stores private keys seen by ssh. 
- A command to store private key passphrases like password manager.
- A daemon or service that stores private key passphrases in memory.

# Question 6
Which program do you use to re-generate a pair of ssh keys?

## correct options
- ssh-keygen
## incorrect options
- ssh-add
- ssh-agent
- ssh-keyscan

# Question 7
Defend or refute the following statement in 3-5 sentences:

The two most important types of software documentation is user reference material and comments in the source code.

# Question 8
Provide a definition of domain knowledge and describe its value in software engineering. (3 - 5 sentences)

## correct options
- 
## incorrect options
- 
- 
- 
