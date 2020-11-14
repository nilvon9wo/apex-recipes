public inherited sharing class FilesRecipes {
    private DAO_ContentDocumentLinkSelector contentDocumentLinkSelector;
    private DAO_ContentVersionSelector contentVersionSelector;
    private XAP_COLL_SObjectValueSetExtractor setExtractor;
    private XAP_DAO_DML_SecureDml dml;

    public FilesRecipes(
            DAO_ContentDocumentLinkSelector contentDocumentLinkSelector,
            DAO_ContentVersionSelector contentVersionSelector,
            XAP_COLL_SObjectValueSetExtractor setExtractor,
            XAP_DAO_DML_SecureDml dml
    ) {
        this.contentDocumentLinkSelector = contentDocumentLinkSelector;
        this.contentVersionSelector = contentVersionSelector;
        this.setExtractor = setExtractor;
        this.dml = dml;
    }

    public FilesRecipes() {
        this(
                DAO_ContentDocumentLinkSelector.getInstance(),
                DAO_ContentVersionSelector.getInstance(),
                XAP_COLL_SObjectValueSetExtractor.getInstance(),
                XAP_DAO_DML_SecureDml.getInstance()
        );
    }

    private static final Map<GenericFileType, Set<String>> FILE_EXTENSION_BY_FILE_TYPE
            = new Map<GenericFileType, Set<String>>{
                    GenericFileType.ALL => null,
                    GenericFileType.AUDIO => new Set<String>{'M4A'},
                    GenericFileType.DOCUMENT => new Set<String>{'WORD_X', 'EXCEL_X', 'POWER_POINT_X', 'PDF'},
                    GenericFileType.IMAGE => new Set<String>{'JPG', 'GIF', 'PNG', 'JPEG'}
            };


    public XAP_DAO_DML_SaveResultListWrapper createFileFromStringAttachedToRecord(String text, Id firstLocation) {
        return this.createFileAttachedToRecord(Blob.valueOf(text), firstLocation, 'AwesomeFile1');
    }

    public XAP_DAO_DML_SaveResultListWrapper createFileAttachedToRecord(Blob fileContents, Id attachedTo, String fileName) {
        return this.createFileAttachedToRecord(new ContentVersion(
                ContentLocation = 'S',
                FirstPublishLocationId = attachedTo,
                PathOnClient = fileName,
                Title = fileName,
                VersionData = fileContents
        ));
    }

    public XAP_DAO_DML_SaveResultListWrapper createFileAttachedToRecord(ContentVersion fileToUpload) {
        XAP_DAO_DML_SaveResultListWrapper saveResult;
        try {
            saveResult = this.dml.doInsert(new List<ContentVersion>{fileToUpload});
        }
        catch (DmlException dmlException) {
            System.debug(LoggingLevel.ERROR, 'Failed to insert fileToUpload, error is: ' + dmlException.getMessage());
        }
        return saveResult;
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public List<ContentVersion> getFilteredAttachmentsForRecord(
            GenericFileType genericFileType,
            Id linkedEntityId
    ) {
        Set<String> fileExtensionSet = FILE_EXTENSION_BY_FILE_TYPE.get(genericFileType);
        List<ContentDocumentLink> linkList
                = this.contentDocumentLinkSelector.secureSelectByLinkedEntityAhdFileType(linkedEntityId, fileExtensionSet);

        Set<Id> fileIdSet = this.setExtractor.extractNonNullIdsFrom(linkList, ContentDocumentLink.ContentDocumentId);
        return this.contentVersionSelector.secureSelectByDocumentId(fileIdSet);
    }

    public XAP_DAO_DML_SaveResultListWrapper publishContent(ContentDocumentLink contentDocumentLink) {
        return this.publishContent(new ContentDistribution(
                ContentVersionId = contentDocumentLink.ContentDocument.LatestPublishedVersionId,
                Name = 'new distributrion of content',
                PreferencesAllowOriginalDownload = true,
                PreferencesAllowPDFDownload = true,
                PreferencesAllowViewInBrowser = true,
                RelatedRecordId = contentDocumentLink.LinkedEntityId
        ));
    }
    public XAP_DAO_DML_SaveResultListWrapper publishContent(ContentDistribution contentDistribution) {
        try {
            return this.dml.doInsert(new List<ContentDistribution>{contentDistribution});
        }
        catch (DmlException dmlException) {
            System.debug(LoggingLevel.ERROR, dmlException.getMessage());
            throw new FilesRecipesException(dmlException.getMessage());
        }
    }
}
