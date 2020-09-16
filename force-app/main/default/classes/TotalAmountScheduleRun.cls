public with sharing class TotalAmountScheduleRun {
    public static void runSchedule() {
        TotalAmountSchedule totalAmountSchedule = new TotalAmountSchedule();
        String CRON_EXP = '0 0 18 * * FRI *';
        System.schedule('Every Friday Update', CRON_EXP, totalAmountSchedule);
    }
}
