brew install jq coreutils

latest_release_name=$(curl -X GET "https://gitlab.com/api/v4/projects/12294987/releases" | jq --raw-output '.[0].tag_name')

echo $latest_release_name

archive_url="https://gitlab.com/ligolang/ligo/-/archive/${latest_release_name}/ligo-${latest_release_name}.tar.gz"
release_sha256=$(curl -L --fail $archive_url | sha256sum | cut -d " " -f 1)

echo $archive_url
echo $release_sha256

sed -i "s| url \".*\"| url \"${archive_url}\"|g" ./Formula/ligo.rb
sed -i "s|sha256 \".*\"|sha256 \"${release_sha256}\"|g" ./Formula/ligo.rb