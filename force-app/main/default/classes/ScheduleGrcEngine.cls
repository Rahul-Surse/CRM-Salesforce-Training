/***************************************************************************************************
* @Author:        CRM Developer
* @className:     ScheduleGrcEngine
* @Description:   This class is a scheduler class of GenericRecordCreationEngine
***************************************************************************************************/
public with sharing class ScheduleGrcEngine implements Schedulable {
    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method create Object of  GenericRecordCreationEngine and call method processEvent
                      after specifice time of interval
    * @Param1:        sc:- The reference of Schedulable context.
    ***************************************************************************************************/
    public void execute(SchedulableContext sc) {
        GenericRecordCreationEngine grcEngine = new GenericRecordCreationEngine();
        grcEngine.objectCreation();
        
        String day = string.valueOf(system.now().day());

        String month = string.valueOf(system.now().month());

        String hour = string.valueOf(system.now().hour());

        String minute = string.valueOf(system.now().minute() + 1);

        String second = string.valueOf(system.now().second());

        String year = string.valueOf(system.now().year());

        String strJobName = 'Job-' + second + '_' + minute + '_' + hour + '_' + day + '_' + month + '_' + year;

        String strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?' + ' ' + year;

        System.schedule(strJobName, strSchedule, new ScheduleGrcEngine());

    }
}


