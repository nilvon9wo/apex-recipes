public inherited sharing class ApexClassUtilities {
    public String getGroupFromClassBody(ApexClass klass) {
        return this.getFromClassBody(
                klass,
                '.*@group.(.*)',
                'Failed to extract group names. Class name: '
        );
    }

    public String getRelatedClassesFromClassBody(ApexClass klass) {
        return this.getFromClassBody(
                klass,
                '.*@see.(.*)',
                'Failed to extract related names. Class name: '
        );
    }

    private String getFromClassBody(ApexClass klass, String regexString, String errorMessage) {
        return this.getFromClassBody(klass, Pattern.compile(regexString), errorMessage);
    }

    private String getFromClassBody(ApexClass klass, Pattern pattern, String errorMessage) {
        return this.getFromClassBody(klass, pattern.matcher(klass.Body), errorMessage);
    }

    private String getFromClassBody(ApexClass klass, Matcher matcher, String errorMessage) {
        matcher.find();
        try {
            return matcher.group(1);
        }
        catch (StringException matcherException) {
            System.debug(LoggingLevel.ERROR, errorMessage + klass.Name);
        }
        return '';
    }
}
