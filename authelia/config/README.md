# Authelia Configuration

## configuration.yml

This is a reasonably complete file but some details need added. The appropriate pages / domains would need to be entered and some secrets need to be added. Just read through it and change those things that look like they need to be.


## users_database.yml

This file would have to be created and the passwords generated. There is a command line switch in authelia to use the application to generate the passwords from cleartext.

```yaml
###############################################################
#                         Users Database                      #
###############################################################

# This file can be used if you do not have an LDAP set up.

# List of users - change username to desired user
users:
  username:
    displayname: "Your Name"
    # See documentation for docker command to create hashed password
    password: "$argon2id$v=19$m=65536,t=1,p=8$cUI4a0E3L1laYnRDUXl3Lw$ZsdsrdadaoVIaVj8NltA8x4qVOzT+/r5GF62/bT8OuAs" 
    email: you@example.com
    groups:
      - admins
      - dev

```
