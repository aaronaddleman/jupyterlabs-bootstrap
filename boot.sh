# is USE_PATHS set? then append it!
[ -n "${USE_HOME_BIN}" ] && export PATH=$HOME/.local/bin:$HOME/bin:$PATH

# are some links missing and they exist elsewhere? then link them!
[ ! -L $HOME/.spacemacs ] && [ -f /data/dotfiles/.spacemacs ] && ln -s /data/dotfiles/.spacemacs $HOME/.spacemacs
[ ! -L $HOME/.vimrc ] && [ -f /data/dotfiles/.vimrc ] && ln -s /data/dotfiles/.vimrc $HOME/.vimrc

# is USE_EMACS_DAEMON set? then launch it in the background
[ -n "${USE_EMACS_DAEMON}" ] && pgrep -x emacs >/dev/null || emacs --daemon &> /dev/null &
# is USE_EMACS_DAEMON set? then set an alias for the client
[ -n "${USE_EMACS_DAEMON}" ] && alias emacs="emacsclient -c"

# is USE_RVM set and RVM command does not exist? then install it!
if [ -n "${USE_RVM}" ] && [ ! -d $HOME/.rvm ]; then
  [ type "gpg" &> /dev/null ] || sudo apt update && sudo apt install -y gnupg2 ca-certificates
  [ ! -d $HOME/.rvm ] && command curl -sSL https://rvm.io/mpapis.asc | gpg2 --import - && command curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -
  [ ! -d $HOME/.rvm ] && curl -sSL https://get.rvm.io | bash -s stable
fi

# is USE_RVM set and RVM exists? then try loading it!
[ -n "$USE_RVM" ] && [ -f $HOME/.rvm/scripts/rvm ] && source $HOME/.rvm/scripts/rvm

# is USE_HASKELL set and not installed? then install it!
[ -n "$USE_HASKELL" ] && [ ! $(command -v "ghc") ] && sudo apt-get install -y haskell-platform

# is USE_OMZ set and not installed? then install it!
[ -n "$USE_OMZ" ] && [ ! -d "$HOME/.oh-my-zsh" ] && wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
# is USE_OMZ set and the file exists? then load it!
[ -n "$USE_OMZ" ] && [ -f "$HOME/.zshrc" ] && source $HOME/.zshrc

# is USE_OMZ_PLUGS set and they are not installed? then install them and reload .zshrc
if [ -n $USE_OMZ_EXTRA_PLUGS ]; then
  for plugin in $(echo $USE_OMZ_EXTRA_PLUGS | tr ',' ' '); do
    [ ! -d $ZSH_CUSTOM/plugins/$plugin ] && git clone git://github.com/zsh-users/$plugin $ZSH_CUSTOM/plugins/$plugin
  done
fi

[ -n $USE_OMZ_PLUGS ] && sed -i "s/plugins=.*/plugins=(${USE_OMZ_PLUGS})/g" ~/.zshrc

# load OMZ again...
[ -n "$USE_OMZ" ] && [ -f "$HOME/.zshrc" ] && source $HOME/.zshrc

# is SRC_DIR defined and does it exist? then link it
[ -n "${SRC_DIR}" ] && [ -d "${SRC_DIR}" ] && [ ! -L $HOME/src ] && ln -s $SRC_DIR $HOME/src

# is USE_CLOJURE defined and is it not installed? then install it!
[ -n "${USE_CLOJURE}" ] && [ ! $(command -v "clojure") ] && \
  curl -O https://download.clojure.org/install/linux-install-1.10.0.442.sh && \
  chmod +x linux-install-1.10.0.442.sh && \
  sudo ./linux-install-1.10.0.442.sh
# is USE_CLOJURE defined and java is not installed? install it!
[ -n "${USE_CLOJURE}" ] && [ ! $(command -v "java") ] && sudo apt install -y default-jre

# is USE_LEIN defined and is it not installed? then install it!
[ -n "${USE_LEIN}" ] && [ ! $(command -v "lein") ] && \
  sudo curl -o /usr/local/bin/lein https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && \
  sudo chmod +x /usr/local/bin/lein

# is USE_KUBECTL set and not installed? install it!
[ -n "${USE_KUBECTL}" ] && [ ! -f /usr/local/bin/kubectl ] && \
    sudo curl -o /usr/local/bin/kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/linux/amd64/kubectl && \
    sudo curl -o /usr/local/bin/kubectl.sha256 https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/linux/amd64/kubectl.sha256
# is USE_KUBECTL set and not executeable? then chmod +x it!
[ -n "${USE_KUBECTL}" ] && [ ! -x /usr/local/bin/kubectl ] && \
    cd /usr/local/bin && openssl sha1 -sha256 kubectl && cd - && \
    sudo chmod +x /usr/local/bin/kubectl
# is USE_AWS_IAM_AUTHENTICATOR set and not installed? install it
[ -n "${USE_AWS_IAM_AUTHENTICATOR}" ] && [ ! $(command -v "aws-iam-authenticator" ) ] && \
    sudo curl -o /usr/local/bin/aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/linux/amd64/aws-iam-authenticator && \
    sudo curl -o /usr/local/bin/aws-iam-authenticator.sha256 https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/linux/amd64/aws-iam-authenticator.sha256
# is USE_AWS_IAM_AUTHENTICATOR set and not executable? then chmod +x it!
[ -n "${USE_AWS_IAM_AUTHENTICATOR}" ] && [ ! -x /usr/local/bin/aws-iam-authenticator ] && \
    cd /usr/local/bin && openssl sha1 -sha256 aws-iam-authenticator && cd - && \
    sudo chmod +x /usr/local/bin/aws-iam-authenticator

# is USE_VAULT set and not installed? install it!
[ -n "${USE_VAULT}" ] && [ ! $(command -v "vault") ] && \
    mkdir -p $HOME/bin && \
    curl -o $HOME/bin/vault.zip https://releases.hashicorp.com/vault/1.0.1/vault_1.0.1_linux_amd64.zip && \
    unzip $HOME/bin/vault.zip -d $HOME/bin

