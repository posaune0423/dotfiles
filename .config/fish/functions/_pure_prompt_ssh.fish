function _pure_prompt_ssh
    if test "$SSH_CONNECTION" != ""
        echo "$pure_symbol_ssh_prefix"(_pure_user_at_host)
    else if set --query pure_show_username; and test "$pure_show_username" = true
        set --local username (id -u -n)
        set --local username_color (_pure_set_color $pure_color_username_normal)

        if test "$username" = root
            set username_color (_pure_set_color $pure_color_username_root)
        end

        echo "$username_color$username"
    end
end
