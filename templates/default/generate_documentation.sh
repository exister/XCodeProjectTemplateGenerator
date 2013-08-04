#!/bin/sh

/usr/local/bin/appledoc --project-name "__TESTING__" --project-company "__ORGANIZATION_NAME__" --company-id "__PACKAGE__" --logformat xcode --keep-intermediate-files --no-repeat-first-par --no-warn-invalid-crossref --no-warn-missing-arg --exit-threshold 2 --output "./help" ${SRCROOT}/__TESTING__