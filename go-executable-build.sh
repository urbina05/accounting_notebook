#Before we can use the script, we have to make it executable with the chmod command:
#chmod +x ./go-executable-build.sh
#then we can use it  ./go-executable-build.sh yourpackage
#!/usr/bin/env bash

package=$1
if [[ -z "$package" ]]; then
  echo "usage: $0 <package-name>"
  exit 1
fi
package_name=$package

#the full list of the platforms: https://golang.org/doc/install/source#environment
platforms=(
"darwin/386"
"darwin/amd64"
"linux/386"
"linux/amd64"
"windows/386"
"windows/amd64" )

for platform in "${platforms[@]}"
do
    platform_split=(${platform//\// })
    GOOS=${platform_split[0]}
    GOARCH=${platform_split[1]}
    output_name=$package_name'-'$GOOS'-'$GOARCH
    if [ $GOOS = "windows" ]; then
        output_name+='.exe'
    fi

    env GOOS=$GOOS GOARCH=$GOARCH go build -o $output_name $package
    if [ $? -ne 0 ]; then
        echo 'An error has occurred! Aborting the script execution...'
        exit 1
    fi
done
