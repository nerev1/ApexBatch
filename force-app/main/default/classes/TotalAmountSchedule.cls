global class TotalAmountSchedule implements Schedulable {

    public static String CRON_EXP = '0 0 18 ? * FRI *';

    global void execute(SchedulableContext ctx) {
        TotalAmountBatch batchAmount = new TotalAmountBatch();
        Database.executeBatch(batchAmount);
    }
}
