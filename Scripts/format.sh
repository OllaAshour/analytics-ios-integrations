#!/bin/sh

# Move to parent directory to format and lint
cd ..


# Run clang-format to format files
# Successful formatting does not log any messages, but files will be changed...

echo "$(tput setaf 4) Formatting Code"

ls Integrations/*/Source/Core/*.[hm] | xargs clang-format -i -style=file

