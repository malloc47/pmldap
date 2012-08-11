# pmldap
poor man's LDAP

# Description

Fed up of the overhead of "lightweight" directory services (read: [LDAP][1]) 
or configuration management services (e.g., [Puppet][2]), I
finally cobbled together the part that everyone uses: distributing key
documents among machines.

LDAP (and, heaven help us, NIS) just isn't right for handling small
Linux networks (5-20 machines) consisting mainly of homogeneous
workstations.  My particular pain point is lab-style networks, where
all members of the lab should have an account on every workstation
since desks are on a first-come first-serve basis.  Since I've been
dealing with this scenario before the common configuration management
solutions were popularized, `pmldap` duplicates some effort.  Since it
is written in plain-vanilla `bash`, `pmldap` is far simpler and less
comprehensive.  But if all you need to do is synchronize a few key
files, dealing with the overhead of directory or configuration
management services is overkill.

# Setup/Use

* Setup machines with ssh access and configure a server with ssh
  aliases (in `.ssh/config` or `/etc/hosts`) for each machine name
  (thus far, `pmldap` only partly handles this, with the
  `authorize-machine` script--free to pull request more complete
  functionality).  Update the `config` file with the files/paths
  desired.
  
* Place all machine names in the `machines` file, one on each line.

* Create a `shared` folder, underneath which is the full path to the
  files you want merged with the client machines.  E.g.,
  `shared/etc/passwd` would contain the additional users you wish to
  add to the client systems.

* Run the `setup` script to copy all the necessary source files from
  the target machines into the `source` folder.  At this point, there
  is a "clean" set of files in the `shared` folder that will be merged
  with the `source` files.  Every file in the `source` folder will be
  merged with the files in the `shared` folder according to its
  extension: `.before` will be merged before, `after` will go after
  the shared contents, and the plain file will override the contents
  of the shared files.  You should manually update files depending on
  whether you them merged before or after (not doing anything results
  in no merge).
  
* The `sync` script will handle the actual file merging in a
  `transfer` directory and `scp` these files to the client machines.
  Thanks to the merging, you can keep, say, a canonical list of users
  under the `shared` folder and these will be merged with the system
  users copied from the `setup` script.
  
# Auxiliary Scripts
  
* `cmd` script will run a command (say, apt-get, yum, pacman, etc.) on
  all the client machines.
  
* `useradd` is a simplified `bash` reimplementation of the `passwd`
  command that operates on the `shared` folder instead of the system
  folder.  It also generates the text of an email (derived from the
  `message` file) that may contain instructions for new network users.
  
* The `authorize-machine` script can be used to copy the appropriate
  `authorized_keys` file to the client machines for bootstrapping.

# Group Support

If the first argument to `sync` or `cmd` is a file, then `pmldap` will
use this file as the machine list, effectively synchronizing or
running a command on the specified group of machines.  For example, in
a heterogeneous environment in which you have Red Hat and Debian
machines in the `machines` file, you may wish to create `debian` and
`redhat` files, containing the list of machines that run Debian and
Red Hat, respectively.  You may then use

    ./cmd debian apt-get ...
    ./cmd redhat yum ...

to install packages on different groups of machines.

# Dependencies

bash, openssl, ssh

# Notes

Test these scripts in a sandbox environment first.  I am not
responsible for `pmldap` (or anything else) doing damage.  There is a
`DRYRUN` parameter in the

---

Jarrell Waggoner  
/-/ [malloc47.com](http://www.malloc47.com)

[1]: http://en.wikipedia.org/wiki/Lightweight_Directory_Access_Protocol
[2]: http://puppetlabs.com/
