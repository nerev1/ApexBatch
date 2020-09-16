global class TotalAmountSchedule implements Schedulable {

    global void execute(SchedulableContext ctx) {
        TotalAmountBatch batch = new TotalAmountBatch();
        Id batchId = Database.executeBatch(batch);
    }
}
