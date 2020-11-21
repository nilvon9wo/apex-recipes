// @group Shared Code
 public inherited sharing class CollectionUtils {
    public static Map<Id, SObject> mapLastQualifiedSObjectBySpecifiedIdField(
            List<SObject> homogenousSObjectList,
            SObjectField idField
    ) {
        String sObjectTypeString = String.valueOf(homogenousSObjectList[0]?.getSObjectType());
        Type dynamicMapType = Type.forName('Map<Id,' + sObjectTypeString + '>');

        Map<Id, SObject> returnValues = (Map<Id, SObject>) dynamicMapType.newInstance();
        for (SObject current : homogenousSObjectList) {
            if (current.get(idField) != null) {
                returnValues.put((Id) current.get(idField), current);
            }
        }
        return returnValues;
    }

    public static Map<String, SObject> mapLastQualifiedSObjectBySpecifiedStringField(
            List<SObject> homogenousSObjectList,
            SObjectField stringField
    ) {
        String sObjectTypeString = String.valueOf(homogenousSObjectList[0]?.getSObjectType());
        Type dynamicMapType = Type.forName('Map<String,' + sObjectTypeString + '>');
        Map<String, SObject> returnValues = (Map<String, SObject>) dynamicMapType.newInstance();
        for (SObject current : homogenousSObjectList) {
            if (current.get(stringField) != null) {
                returnValues.put((String) current.get(stringField), current);
            }
        }
        return returnValues;
    }

    public static Map<Id, List<SObject>> mapBySpecifiedIdField(
        List<SObject> homogenousSObjectList,
        SObjectField idField
    ) {
        String sObjectTypeString = String.valueOf(homogenousSObjectList[0]?.getSObjectType());
        String sObjectListTypeString = 'List<' + sObjectTypeString + '>';
        Type dynamicListType = Type.forName(sObjectListTypeString);
        Type dynamicMapType = Type.forName('Map<Id, ' + sObjectListTypeString + '>');

        Map<Id, List<SObject>> valueListByIdMap = (Map<Id, List<SObject>>) dynamicMapType.newInstance();
        for (SObject current : homogenousSObjectList) {
            Id currentId = (Id) current.get(idField);
            if (currentId != null) {
                List<SObject> sObjectList = valueListByIdMap.get(currentId);
                if (sObjectList == null) {
                    sObjectList = (List<SObject>) dynamicListType.newInstance();
                    valueListByIdMap.put(currentId, sObjectList);
                }
                sObjectList.add(current);
            }
        }
        return valueListByIdMap;
    }
}
