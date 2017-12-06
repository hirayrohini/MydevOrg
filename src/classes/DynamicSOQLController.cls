public class DynamicSOQLController
{
    public Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    public String selectedObject {get; set;}
    public String selectedField {get; set;}
    public SelectOption[] leftOptions {get;set;}
    public SelectOption[] rightOptions {get;set;}
    public SelectOption[] selectedFields {get;set;}
    public SelectOption[] allFields {get;set;}
    public String message {get;set;}
    public String numberOfRecords {get;set;}
    public String sortOrder {get;set;}
    public String buildQuery {get;set;}
    public String commaSepratedFields;

    Public DynamicSOQLController()
    {   
        selectedObject = 'account';
        selectedFields = new List<SelectOption>();   
        allFields = new List<SelectOption>();
    }

    public List<SelectOption> getObjectNames() 
    {
        List<SelectOption> objNames = new List<SelectOption>();
        List<String> entities = new List<String>(schemaMap.keySet());
        system.debug('entities---'+entities);
        entities.sort();
        for(String name : entities)
        {
            name = name.substring(0,1).toUpperCase()+name.substring(1,name.length());
            objNames.add(new SelectOption(name,name));
        }
        system.debug('Objects----'+objNames);
        return objNames;
    }

    public List<SelectOption> getObjectFields() 
    {
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType ObjectSchema = schemaMap.get(selectedObject);
        Map<String, Schema.SObjectField> fieldMap = ObjectSchema.getDescribe().fields.getMap();
        List<SelectOption> fieldNames = new List<SelectOption>();
        commaSepratedFields = '';
        for(String fieldName: fieldMap.keySet()) 
        {  
            fieldName = fieldName.substring(0,1).toUpperCase()+fieldName.substring(1,fieldName.length());
            fieldNames.add(new SelectOption(fieldName,fieldName));
        }
        system.debug('selectedObject------'+selectedObject);
        return fieldNames;
    } 

    public List<SelectOption> getRecordCountOptions() {
        List<SelectOption> recordCountOptions = new List<SelectOption>();
        recordCountOptions.add(new SelectOption('500','500'));
        recordCountOptions.add(new SelectOption('1000','1000'));
        recordCountOptions.add(new SelectOption('5000','5000'));
        recordCountOptions.add(new SelectOption('50000','50000'));
        return recordCountOptions;
    }

    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Ascending','Ascending')); 
        options.add(new SelectOption('Descending','Descending')); 
        return options; 
    }

    private void setOptions(SelectOption[] options, String value) {
        options.clear();
        String[] parts = value.split('&');
        for (Integer i=0; i<parts.size()/2; i++) {
            options.add(new SelectOption(EncodingUtil.urlDecode(parts[i*2], 'UTF-8'), 
              EncodingUtil.urlDecode(parts[(i*2)+1], 'UTF-8')));
        }
    }
     
    public String leftOptionsHidden { get; set {
           leftOptionsHidden = value;
           setOptions(leftOptions, value);
        }
    }
     
    public String rightOptionsHidden { get; set {
           rightOptionsHidden = value;
           setOptions(rightOptions, value);
        }
    }
  
    public PageReference save() {
        message = 'Selected Fields: ';
        Boolean first = true;
        for ( SelectOption so : selectedFields) {
            if (!first) {
                message += ', ';
            }
            message += so.getLabel() + ' (' + so.getValue() + ')';
            first = false;
        }
        return null;       
    }

    public string getRecords() {
        system.debug('selectedObject---'+selectedObject);
        system.debug('seletedFields----'+selectedfields);
        system.debug('commaSepratedFields----'+commaSepratedFields);
        //for (String fieldName : selectedfields) {
        //    if(commaSepratedFields == null || commaSepratedFields == ''){
        //        commaSepratedFields = fieldName;
        //    }else{
        //        commaSepratedFields = commaSepratedFields + ', ' + fieldName;
        //    }
        //}
        return null;
    }
}