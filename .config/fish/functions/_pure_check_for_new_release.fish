function _pure_check_for_new_release \
    --description "Check for new release and show command to install"

    if test "$pure_check_for_new_release" = true
        echo "🛈 Checking for new release…"
        set latest (pure_get_latest_release_version "pure-fish/pure")

        if test "v"$pure_version != $latest
            echo -e "🔔 New version available!\n"
            echo -e (_pure_set_color $pure_color_success)"fisher install pure-fish/pure@"(_pure_set_color $pure_color_info)$latest(_pure_set_color $pure_color_normal)"\n"
        end
    end
end
