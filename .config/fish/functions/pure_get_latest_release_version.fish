function pure_get_latest_release_version \
    --argument-names user_repo

    curl \
        --silent \
        "https://api.github.com/repos/$user_repo/releases/latest" \
        | string match --regex '"tag_name": "\K.*?(?=")'
end
