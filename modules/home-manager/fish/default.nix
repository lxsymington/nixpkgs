{ self, inputs, config, pkgs, ... }:

{
  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''
        fish_vi_key_bindings

        if test -e ~/.seccl/env.sh -a -x ~/.seccl/env.sh
          replay source ~/.seccl/env.sh
        end
      '';
      functions = {
        update_nix_index = {
          description = "Update the nix-index for `comma`";
          # Currently there is no index available for `aarch64-darwin`
          # onEvent = "fish_prompt";
          body = ''
            set -l filename "index-${pkgs.system}"
            mkdir -p ~/.cache/nix-index
            pushd ~/.cache/nix-index
            # -N will only download a new version if there is an update.
            wget -q -N https://github.com/Mic92/nix-index-database/releases/latest/download/$filename
            ln -f $filename files
            popd
          '';
        };
        # Required for first time AUTO_OPS setup
        nvm = {
          description = "nvm";
          body = ''
            replay source ~/.nvm/nvm.sh --no-use ';' nvm $argv
          '';
        };
        nvm_find_nvmrc = {
          description = "find nvmrc";
          body = ''
            replay source ~/.nvm/nvm.sh --no-use ';' nvm_find_nvmrc
          '';
        };
        load_nvm = {
          description = "load nvmrc";
          onVariable = "PWD";
          body = ''
            set -l default_node_version (nvm version default)
            set -l node_version (nvm version)
            set -l nvmrc_path (nvm_find_nvmrc)
            if test -n "$nvmrc_path"
              set -l nvmrc_node_version (nvm version (cat $nvmrc_path))
              if test "$nvmrc_node_version" = "N/A"
                nvm install (cat $nvmrc_path)
              else if test "$nvmrc_node_version" != "$node_version"
                nvm use $nvmrc_node_version
              end
            else if test "$node_version" != "$default_node_version"
              echo "Reverting to default Node version"
              nvm use default
            end
          '';
        };
      };
      plugins = [
        {
          name = "done";
          src = pkgs.fetchFromGitHub {
            owner = "franciscolourenco";
            repo = "done";
            rev = "d6abb267bb3fb7e987a9352bc43dcdb67bac9f06";
            sha256 = "1h8v5jg9kkali50qq0jn0i1w68wp4c2l0fapnglnnpg0v4vv51za";
          };
        }
        {
          name = "fish-ssh-agent";
          src = pkgs.fetchFromGitHub {
            owner = "danhper";
            repo = "fish-ssh-agent";
            rev = "fd70a2afdd03caf9bf609746bf6b993b9e83be57";
            sha256 = "1fvl23y9lylj4nz6k7yfja6v9jlsg8jffs2m5mq0ql4ja5vi5pkv";
          };
        }
        {
          name = "fzf";
          src = pkgs.fetchFromGitHub {
            owner = "jethrokuan";
            repo = "fzf";
            rev = "479fa67d7439b23095e01b64987ae79a91a4e283";
            sha256 = "0k6l21j192hrhy95092dm8029p52aakvzis7jiw48wnbckyidi6v";
          };
        }
        {
          name = "pisces";
          src = pkgs.fetchFromGitHub {
            owner = "laughedelic";
            repo = "pisces";
            rev = "e45e0869855d089ba1e628b6248434b2dfa709c4";
            sha256 = "073wb83qcn0hfkywjcly64k6pf0d7z5nxxwls5sa80jdwchvd2rs";
          };
        }
        {
          name = "replay";
          src = pkgs.fetchFromGitHub {
            owner = "jorgebucaran";
            repo = "replay.fish";
            rev = "bd8e5b89ec78313538e747f0292fcaf631e87bd2";
            sha256 = "0inniabgdbd7yq71rpmpnzhbk8y23ggvlk4jhaapc7bz0yhbxkkc";
          };
        }
      ];
    };
  };
}
