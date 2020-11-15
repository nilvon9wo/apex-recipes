public inherited sharing class ApexClassUtilities {
    public String getGroupFromClassBody(ApexClass klass) {
        return this.getFromClassBody(
                klass,
                Pattern.compile('.*@group.(.*)'),
                'Failed to extract group names. Class name: '
        );
    }

    public String getRelatedClassesFromClassBody(ApexClass klass) {
        return this.getFromClassBody(
                klass,
                Pattern.compile('.*@see.(.*)'),
                'Failed to extract related names. Class name: '
        );
    }

    public String getFromClassBody(ApexClass klass, Pattern pattern, String errorMessage) {
        Matcher matcher = pattern
                .matcher(klass.Body);
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
