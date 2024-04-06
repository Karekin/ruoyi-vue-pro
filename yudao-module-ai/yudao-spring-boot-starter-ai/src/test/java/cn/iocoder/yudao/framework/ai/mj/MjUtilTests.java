package cn.iocoder.yudao.framework.ai.mj;

import cn.iocoder.yudao.framework.ai.midjourney.util.MjUtil;
import org.junit.Test;

/**
 * mj util
 *
 * author: fansili
 * time: 2024/4/6 21:57
 */
public class MjUtilTests {

    @Test
    public void parseContentTest() {
        String content1 = "**南极应该是什么样子？ --v 6.0 --style raw** - <@972721304891453450> (32%) (fast, stealth)";
        String content2 = "**南极应该是什么样子？ --v 6.0 --style raw** - <@972721304891453450> (fast, stealth)";

        System.err.println(MjUtil.parseContent(content1));
        System.err.println(MjUtil.parseContent(content2));
    }
}
