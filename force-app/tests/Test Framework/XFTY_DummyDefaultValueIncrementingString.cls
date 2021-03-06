@IsTest
public class XFTY_DummyDefaultValueIncrementingString implements XFTY_DummyDefaultValueIntf {
    public static final Boolean SEPARATE_PREFIX = true;
    public static final Boolean DONT_SEPARATE_PREFIX = false;

    private String prefix;
    private Boolean separatePrefix;

    private Integer counter = 1;

    public XFTY_DummyDefaultValueIncrementingString(String prefix, Boolean separatePrefix) {
        this.prefix = prefix;
        this.separatePrefix = separatePrefix;
    }

    public XFTY_DummyDefaultValueIncrementingString(String prefix) {
        this(prefix, SEPARATE_PREFIX);
    }

    public Object get() {
        String separator = (this.separatePrefix)
                ? ' '
                : '';
        return this.prefix + separator + counter++;
    }
}