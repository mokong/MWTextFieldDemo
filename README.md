# MWTextFieldDemo
输入框限制最大输入


## 背景

小知识点记录，textField的`markedTextRange`的使用，如果你已经知道了，就不需要再看了。

iOS输入框字符限制，不同实现方式的对比：

- 方法1，通过监听textField的`UIControl.Event.editingChanged`，在对应的方法里做长度拦截判断
- 方法2，通过textField的代理方法，`textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool`判断。

<!--more-->

## 对比

假设产品要求这个输入框限制输入6个字，怎么判断？下面来看下

### 方法1

声明一个自定义的MWCustomTF，然后监听`editingChanged`事件，在事件里判断输入字符是否超出最大输入长度，代码如下：

``` Swift

class MWCustomTF: UITextField {

    // MARK: - properties
    var kMaxInputLength: Int = 6 // 最大输入长度
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addTarget(self, action: #selector(handleTFChanged(_:)), for: UIControl.Event.editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - utils
    
    
    // MARK: - action
    @objc
    fileprivate func handleTFChanged(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }
        
        let textCount = text.count
        let minCount = min(textCount, kMaxInputLength)
        self.text = (text as NSString).substring(to: minCount)
    }
    
    // MARK: - other

}

```

运行后调试，发现，确实限制了最大输入长度，但是有两个问题：
- 问题1: 在输入中文时，输入拼音也不能超过最大输入长度了，比如：目前最大长度是6，那么输入超过6个单词的拼音时，输入不了，比如想输入上海，直接就把shang显示到输入框中了。
- 问题2: 这种方式，在iOS12.0的手机上会出现，输入拼音时直接把拼音显示到了输入框内，本来是输入拼音选汉字，但是加了这个方法后在iOS12上，输入拼音到过程中直接把拼音就显示到输入框中了，完全乱了。所以iOS12上完全不可用。

效果如下：

![playback1](https://raw.githubusercontent.com/mokong/BlogImages/main/img/PageCallback1.gif)

### 方法2

那既然上面的方法1在iOS12上完全不能用，来试试方法2的实现，即在textField的代理方法中判断，代码如下：

``` Swift

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var textField: UITextField! // Link this to a UITextField in Storyboard

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.delegate = self
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 6
    }
}

```

运行调试，查看运行效果，会发现，首先iOS12上的那种错乱解决了；其次超出6个时不会自动把拼音带入到输入框内，只是限制超出后到输入无效。
所以这种方法，上面的问题解决了，但是还是有一个问题：就是当你输入了5个字后，只能再输入一个拼音，惊不惊喜？

效果如下：

![playback2](https://raw.githubusercontent.com/mokong/BlogImages/main/img/PageCallback2.gif)


所以上面的方法也是不行的，那怎么处理呢？我想要输入拼音时不校验，在选择拼音变成汉字时，再去校验这个长度是否超出？要怎么做呢？

这时就需要textField的`markedTextRange`了，`markedTextRange`的定义如下：

``` Swift

    /* If text can be selected, it can be marked. Marked text represents provisionally
     * inserted text that has yet to be confirmed by the user.  It requires unique visual
     * treatment in its display.  If there is any marked text, the selection, whether a
     * caret or an extended range, always resides within.
     *
     * Setting marked text either replaces the existing marked text or, if none is present,
     * inserts it from the current selection. */
    
    @available(iOS 3.2, *)
    var markedTextRange: UITextRange? { get } // Nil if no marked text.

```

根据`markedTextRange`是否为空，可以判断当前是不是在输入拼音。所以要怎么处理呢？
由于方法一之前不兼容iOS12，所以我们优先考虑在方法二的代理方法中添加`markedTextRange`是否为空的判断，但是在代理方法中打印`textField.markedTextRange`会发现，这个地方打印出来的range比真实的慢一步，即输入了一个拼音时，这个方法中打印出来时nil，输入第二个拼音后，这个方法中打印出来的是`range = 0...1`，所以在这个方法里并不能准确的判断这个值。其实是因为这个方法的调用在前面，这个方法返回了true之后，`markedTextRange`才会变化，所以在这个方法里看到的`markedTextRange`永远是慢一步的。

所以只能是接着用方法一，因为方法一是监听`textField`的`editingChanged`事件，所以这个事件里获取的`markedTextRange`应该是准确的。代码如下：

``` Swift

class MWCustomTF: UITextField {

    // MARK: - properties
    var kMaxInputLength: Int = 6
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addTarget(self, action: #selector(handleEditingChanged(_:)), for: UIControl.Event.editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - utils
    
    
    // MARK: - action
    @objc
    fileprivate func handleEditingChanged(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }
        if sender.markedTextRange != nil {
            return
        }
        
        let textCount = text.count
        let minCount = min(textCount, kMaxInputLength)
        self.text = (text as NSString).substring(to: minCount)
    }
    
    // MARK: - other

}

```

运行调试后，发现完美，当输入拼音时，不校验是否超出最长长度，而选择拼音变为汉字后，超出最长长度的汉字将被截断。binggo，正是我们想要的结果。

最终效果如下：

![playback3](https://raw.githubusercontent.com/mokong/BlogImages/main/img/PageCallback3.gif)

## 参考

- [Max length UITextField](https://stackoverflow.com/questions/25223407/max-length-uitextfield)


