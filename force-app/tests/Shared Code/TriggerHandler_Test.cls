@IsTest
private class TriggerHandler_Test {
    private static final String TRIGGER_CONTEXT_ERROR = 'Trigger handler called outside of Trigger execution';

    private static String lastMethodCalled;

    private static TriggerHandler_Test.TestHandler handler;

    static {
        handler = new TriggerHandler_Test.TestHandler();
        handler.isTriggerExecuting = true;
    }

    @IsTest
    static void testBeforeInsert() {
        beforeInsertMode();
        handler.run();
        System.assertEquals(
            'beforeInsert',
            lastMethodCalled,
            'Last method should be beforeInsert'
        );
    }

    @IsTest
    static void testBeforeUpdate() {
        beforeUpdateMode();
        handler.run();
        System.assertEquals(
            'beforeUpdate',
            lastMethodCalled,
            'Last method should be beforeUpdate'
        );
    }

    @IsTest
    static void testBeforeDelete() {
        beforeDeleteMode();
        handler.run();
        System.assertEquals(
            'beforeDelete',
            lastMethodCalled,
            'Last method should be beforeDelete'
        );
    }

    @IsTest
    static void testAfterInsert() {
        afterInsertMode();
        handler.run();
        System.assertEquals(
            'afterInsert',
            lastMethodCalled,
            'Last method should be afterInsert'
        );
    }

    @IsTest
    static void testAfterUpdate() {
        afterUpdateMode();
        handler.run();
        System.assertEquals(
            'afterUpdate',
            lastMethodCalled,
            'Last method should be afterUpdate'
        );
    }

    @IsTest
    static void testAfterDelete() {
        afterDeleteMode();
        handler.run();
        System.assertEquals(
            'afterDelete',
            lastMethodCalled,
            'Last method should be afterDelete'
        );
    }

    @IsTest
    static void testAfterUndelete() {
        afterUndeleteMode();
        handler.run();
        System.assertEquals(
            'afterUndelete',
            lastMethodCalled,
            'Last method should be afterUndelete'
        );
    }

    @IsTest
    static void testNonTriggerContext() {
        try {
            handler.run();
            System.assert(false, 'The handler ran but should have thrown');
        } catch (TriggerHandlerException te) {
            System.assertEquals(
                TRIGGER_CONTEXT_ERROR,
                te.getMessage(),
                'The exception message should match'
            );
        } catch (Exception e) {
            System.assert(
                false,
                'The exception thrown was not expected: ' +
                e.getTypeName() +
                ': ' +
                e.getMessage()
            );
        }
    }

    @IsTest
    static void testBypassAPI() {
        afterUpdateMode();

        TriggerHandler.bypass('TestHandler');
        handler.run();
        System.assertEquals(
            null,
            lastMethodCalled,
            'Last method should be null when bypassed'
        );
        System.assertEquals(
            true,
            TriggerHandler.isBypassed('TestHandler'),
            'Test handler should be bypassed'
        );
        resetTest();

        TriggerHandler.clearBypass('TestHandler');
        handler.run();
        System.assertEquals(
            'afterUpdate',
            lastMethodCalled,
            'Last method called should be afterUpdate'
        );
        System.assertEquals(
            false,
            TriggerHandler.isBypassed('TestHandler'),
            'Test handler should be bypassed'
        );
        resetTest();

        TriggerHandler.bypass('TestHandler');
        handler.run();
        System.assertEquals(
            null,
            lastMethodCalled,
            'Last method should be null when bypassed'
        );
        System.assertEquals(
            true,
            TriggerHandler.isBypassed('TestHandler'),
            'Test handler should be bypassed'
        );
        resetTest();

        TriggerHandler.clearAllBypasses();
        handler.run();
        System.assertEquals(
            'afterUpdate',
            lastMethodCalled,
            'Last method called should be afterUpdate'
        );
        System.assertEquals(
            false,
            TriggerHandler.isBypassed('TestHandler'),
            'Test handler should be bypassed'
        );
        resetTest();
    }

    @IsTest
    static void testLoopCount() {
        beforeInsertMode();

        handler.setMaxLoopCount(2);

        handler.run();
        handler.run();

        resetTest();

        try {
            handler.run();
            System.assert(
                false,
                'The handler should throw on the 3rd run when maxloopcount is 3'
            );
        } catch (TriggerHandlerException te) {
            // we're expecting to get here
            System.assertEquals(
                null,
                lastMethodCalled,
                'Last method should be null'
            );
        } catch (Exception e) {
            System.assert(
                false,
                'The exception thrown was not expected: ' +
                e.getTypeName() +
                ': ' +
                e.getMessage()
            );
        }

        resetTest();

        handler.clearMaxLoopCount();

        try {
            handler.run();
            System.assertEquals(
                'beforeInsert',
                lastMethodCalled,
                'Last method should be beforeInsert'
            );
        } catch (TriggerHandlerException te) {
            System.assert(
                false,
                'Running the handler after clearing the loop count should not throw'
            );
        } catch (Exception e) {
            System.assert(
                false,
                'The exception thrown was not expected: ' +
                e.getTypeName() +
                ': ' +
                e.getMessage()
            );
        }
    }

    @IsTest
    static void testLoopCountClass() {
        TriggerHandler.LoopCount lc = new TriggerHandler.LoopCount();
        System.assertEquals(5, lc.getMax(), 'Max should be five on init');
        System.assertEquals(0, lc.getCount(), 'Count should be zero on init');

        lc.increment();
        System.assertEquals(1, lc.getCount(), 'Count should be 1');
        System.assertEquals(
            false,
            lc.exceeded(),
            'Should not be exceeded with count of 1'
        );

        lc.increment();
        lc.increment();
        lc.increment();
        lc.increment();
        System.assertEquals(5, lc.getCount(), 'Count should be 5');
        System.assertEquals(
            false,
            lc.exceeded(),
            'Should not be exceeded with count of 5'
        );

        lc.increment();
        System.assertEquals(6, lc.getCount(), 'Count should be 6');
        System.assertEquals(
            true,
            lc.exceeded(),
            'Should not be exceeded with count of 6'
        );
    }

    @IsTest
    static void testGetHandlerName() {
        System.assertEquals(
            'TestHandler',
            handler.getHandlerName(),
            'Handler name should match class name'
        );
    }

    @IsTest
    static void testVirtualMethods() {
        TriggerHandler h = new TriggerHandler();
        h.beforeInsert();
        h.beforeUpdate();
        h.beforeDelete();
        h.afterInsert();
        h.afterUpdate();
        h.afterDelete();
        h.afterUndelete();
        System.assert(
            true,
            'Expected all of these methods to have executed without throwing an exception during tests.'
        );
    }

    private static void resetTest() {
        lastMethodCalled = null;
    }

    private static void beforeInsertMode() {
        handler.setTriggerContext(System.TriggerOperation.BEFORE_INSERT, true);
    }

    private static void beforeUpdateMode() {
        handler.setTriggerContext(System.TriggerOperation.BEFORE_UPDATE, true);
    }

    private static void beforeDeleteMode() {
        handler.setTriggerContext(System.TriggerOperation.BEFORE_DELETE, true);
    }

    private static void afterInsertMode() {
        handler.setTriggerContext(System.TriggerOperation.AFTER_INSERT, true);
    }

    private static void afterUpdateMode() {
        handler.setTriggerContext(System.TriggerOperation.AFTER_UPDATE, true);
    }

    private static void afterDeleteMode() {
        handler.setTriggerContext(System.TriggerOperation.AFTER_DELETE, true);
    }

    private static void afterUndeleteMode() {
        handler.setTriggerContext(System.TriggerOperation.AFTER_UNDELETE, true);
    }

    private class TestHandler extends TriggerHandler {
        public override void beforeInsert() {
            TriggerHandler_Test.lastMethodCalled = 'beforeInsert';
        }

        public override void beforeUpdate() {
            TriggerHandler_Test.lastMethodCalled = 'beforeUpdate';
        }

        public override void beforeDelete() {
            TriggerHandler_Test.lastMethodCalled = 'beforeDelete';
        }

        public override void afterInsert() {
            TriggerHandler_Test.lastMethodCalled = 'afterInsert';
        }

        public override void afterUpdate() {
            TriggerHandler_Test.lastMethodCalled = 'afterUpdate';
        }

        public override void afterDelete() {
            TriggerHandler_Test.lastMethodCalled = 'afterDelete';
        }

        public override void afterUndelete() {
            TriggerHandler_Test.lastMethodCalled = 'afterUndelete';
        }
    }
}
