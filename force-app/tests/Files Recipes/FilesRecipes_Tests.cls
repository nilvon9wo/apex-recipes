@IsTest
private inherited sharing class FilesRecipes_Tests {
    private static final FilesRecipes RECIPES_UNDER_TEST = new FilesRecipes();
    @TestSetup
    static void makeData() {
        Account acct = (Account) TestFactory.createSObject(
            new Account(Name = 'Test Account'),
            true
        );

        StaticResource[] testData = [
            SELECT Id, Body, Name
            FROM StaticResource
            WHERE Name IN ('helloaudio', 'helloworld', 'logo')
        ];

        for (StaticResource resource : testData) {
            String fileName = '';
            if (resource.Name.equalsIgnoreCase('logo')) {
                fileName = resource.Name + '.png';
            } else if (resource.Name.equalsIgnoreCase('helloworld')) {
                fileName = resource.Name + '.docx';
            } else {
                fileName = resource.Name + '.m4a';
            }
            RECIPES_UNDER_TEST.createFileAttachedToRecord(
                resource.Body,
                acct.Id,
                fileName
            );
        }
    }

    @IsTest
    static void testPublishContent() {
        Account acct = [SELECT Id FROM Account LIMIT 1];
        String text = 'Hello Good Friends, enjoy the stream!';
        RECIPES_UNDER_TEST.createFileFromStringAttachedToRecord(text, acct.Id);
        ContentDocumentLink cdl = [
            SELECT Id, LinkedEntityId, ContentDocument.LatestPublishedVersionId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :acct.Id
            LIMIT 1
        ];

        Test.startTest();
        RECIPES_UNDER_TEST.publishContent(cdl);
        Test.stopTest();

        ContentDistribution dist = [
            SELECT Id, ContentDownloadUrl
            FROM ContentDistribution
            WHERE RelatedRecordId = :acct.Id
            LIMIT 1
        ];
        System.assert(
            String.isNotBlank(dist.ContentDownloadUrl),
            'Expected to find a download url'
        );
    }

    @IsTest
    static void testUploadFileFromText() {
        Account acct = [SELECT Id FROM Account LIMIT 1];
        String text = 'Hello Good Friends, enjoy the stream!';

        Test.startTest();
        RECIPES_UNDER_TEST.createFileFromStringAttachedToRecord(text, acct.Id);
        Test.stopTest();

        ContentVersion[] results = [
            SELECT Id, FirstPublishLocationId, Title, PathOnClient
            FROM ContentVersion
            WHERE FirstPublishLocationId = :acct.Id AND Title = 'AwesomeFile1'
        ];

        System.assert(results.size() == 1, 'Expected to find one file');
    }

    @IsTest
    static void testGetFilteredAttachmentsForRecords() {
        Id attachedRecordId = [SELECT Id FROM Account LIMIT 1].Id;

        Test.startTest();
        List<ContentVersion> audioFiles = RECIPES_UNDER_TEST.getFilteredAttachmentsForRecord(
            GenericFileType.AUDIO,
            attachedRecordId
        );
        List<ContentVersion> imageFiles = RECIPES_UNDER_TEST.getFilteredAttachmentsForRecord(
            GenericFileType.IMAGE,
            attachedRecordId
        );
        List<ContentVersion> docFiles = RECIPES_UNDER_TEST.getFilteredAttachmentsForRecord(
            GenericFileType.DOCUMENT,
            attachedRecordId
        );
        List<ContentVersion> all = RECIPES_UNDER_TEST.getFilteredAttachmentsForRecord(
            GenericFileType.ALL,
            attachedRecordId
        );
        Test.stopTest();

        System.assertEquals(
            1,
            audioFiles.size(),
            'Expected to find 1 audio file'
        );
        System.assertEquals(
            1,
            imageFiles.size(),
            'Expected to find 1 image file'
        );
        System.assertEquals(
            1,
            docFiles.size(),
            'Expected to find 1 document file'
        );

        System.assertEquals(3, all.size(), 'Expected to find 3 total files');
    }
}
