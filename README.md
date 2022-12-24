## PROJET LO14 UTT 2022-2023

Il s'agit de simuler un réseau virtuel de machines Linux.

Vous devez créer une nouvelle commande shell, nommée rvsh,
qui fonctionne selon les deux modes suivants:
1er mode: c'est le mode connect. Ce mode s'invoque par:
rvsh -connect nom_machine nom_utilisateur
Cette commande permet de se connecter à une machine
virtuelle avec le nom d’un utilisateur.
2ème mode: c'est le mode admin. Ce mode s'invoque par:
rvsh -admin
Cette commande permet à l’administrateur de gérer la liste des
machines connectées au réseau virtuel et la liste des utilisateurs.

## DESCRIPTION

### MODE CONNECT

Le mode connect permet à un utilisateur de se connecter à une
machine virtuelle (que vous aurez créée préalablement). Si le
nom de l’utilisateur et le nom de la machine virtuelle sont
corrects, la connexion est acceptée (c’est-à-dire l’utilisateur a le
droit de se connecter sur cette machine et son mot de passe est
correct) et l’utilisateur arrive sur le prompt suivant :
nom_utilisateur@nom_machine >
À partir de ce prompt l’utilisateur doit pouvoir exécuter
certaines commandes virtuelles :

##### La commande who
Cette commande permet d’accéder à l’ensemble des utilisateurs
connectés sur la machine. Elle doit renvoyer le nom de chaque
utilisateur, l’heure et la date de sa connexion (Cf. Commande
who de Linux). Attention, un même utilisateur peut se
connecter plusieurs fois sur la même machine à partir de
plusieurs terminaux.

##### La commande rusers
Cette commande permet d’accéder à la liste des utilisateurs
connectés sur le réseau. Elle doit renvoyer le nom de chaque
utilisateur et le nom de la machine où il est connecté, ainsi que
l’heure et la date de sa connexion.
La commande rhost
Cette commande doit renvoyer la liste des machines rattachées
au réseau virtuel.

##### La commande rconnect
Cette commande permet à l’utilisateur de se connecter à une
autre machine du réseau (il faut préalablement vérifier que
l’utilisateur a le droit de se connecter sur cette machine).
La commande su
Cette commande permet de changer d’utilisateur (Cf.
commande su de Linux) sans changer de machine.

##### La commande passwd
Cette commande permet à l’utilisateur de changer de mot de
passe sur l’ensemble du réseau virtuel (Cf. commande passwd
de Linux)

##### La commande finger
Cette commande permet de renvoyer des éléments
complémentaires sur l’utilisateur (Cf. la commande finger de
Linux).

##### La commande write
Cette commande permet d’envoyer un message à un utilisateur
connecté sur une machine du réseau (Cf. la commande write de
Linux). La syntaxe de la commande est la suivante :
write nom_utilisateur@nom_machine message

##### La commande exit
Cette commande permet de sortir d’une machine virtuelle.
Quand un utilisateur est connecté à une machine virtuelle avant
de se connecter à une nouvelle machine, la commande exit
permet de sortir de la machine en cours et revient sur la
machine précédente.
Un utilisateur peut se connecter à la machine A, ensuite à la
machine B et ensuite à la machine C. La commande exit sort de
la machine C et revient sur la machine B. Une nouvelle
commande exit permet de revenir sur la machine A.

### MODE ADMIN

Seul l’administrateur du réseau virtuel doit pouvoir utiliser ce
mode. Donc l’accès à cette commande doit être géré par un mot
de passe (mot de passe de l’administrateur). Une fois la
commande lancée et le mot de passe validé, l’administrateur
arrive sur le prompt suivant :
root@hostroot >

On considère que le réseau virtuel possède dès le début une
machine virtuelle nommée « hostroot » sur laquelle
l’administrateur se connecte quand il utilise le mode admin de
la commande rvsh.
À partir de ce prompt l’administrateur doit pouvoir exécuter les
commandes du mode connect et certaines
commandes complémentaires suivantes :

#### La commande host
Cette commande permet à l’administrateur d’ajouter ou
d’enlever une machine au réseau virtuel.

#### La commande user
Cette commande permet à l’administrateur d’ajouter ou
d’enlever un utilisateur, de lui donner les droits d’accès à une
ou plusieurs machines du réseau et de lui fixer un mot de passe.

#### La commande wall
Cette commande permet à l’administrateur d’envoyer un
message à tous les utilisateurs sur le réseau). La syntaxe de la
commande est la suivante :
wall message : Envoie le message « message » à tous les
utilisateurs connectés.

wall –n message : Envoie le message « message » à tous les
utilisateurs connectés et non connectées. Un utilisateur non
connecté recevra le message lors de sa nouvelle connexion au
réseau.

#### La commande afinger
Cette commande permet à l’administrateur de renseigner les
informations complémentaires sur l’utilisateur (l’utilisateur aura
accès à ces informations avec la commande finger dans le mode
connect).

## POUR FORKER

Utiliser le git clone dans le repertoire de travail de l'utilisateur courant (/home/username ou ~)
