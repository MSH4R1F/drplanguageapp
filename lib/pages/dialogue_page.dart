import 'package:flutter/material.dart';

class DialoguePage extends StatefulWidget {
  const DialoguePage({super.key});

  @override
  State<DialoguePage> createState() => _DialoguePageState();
}

class _DialoguePageState extends State<DialoguePage> {
  @override
  Widget build(BuildContext context) {
    const String text =
        "گاہک بہت اہم ہے، گاہک گاہک کی پیروی کرے گا۔ اس کی کوئی وجہ نہیں ہے۔ یہ زندگی، لیسنیا اور دوا کے نتیجے سے مختلف نہیں تھا. لیکن باسکٹ بال لیگ اس کی پیروی کرے گی، جیسا کہ فٹ بال کی خوشامد کرتے ہیں۔ کچھ تکیے اور چاکلیٹ کارٹون۔ کچھ بھی آسان نہیں ہے۔ اداس خالص الٹریسیز اور تکیہ تک. کچھ تیر مفت ہیں۔ امیر زندگی سے چاپلوسی ہوتی ہے، اور وادی بدصورت ہے۔ ملک کام نہیں کرنا چاہتا۔ یہ موریس کی حاملہ زندگی کا ماتم ہے۔ اب فٹ بال کے شائقین کو پینے کی ضرورت ہے۔ یہ ایک لحاف کی طرح ہے۔ لیکن بچے لائم لائٹ میں ہوتے ہیں، اس لیے بعض اوقات کچھ لوگ پسند کرتے ہیں۔";
    // TODO: implement build
    void showDialogueBox(String text) {
      String filteredText = text.replaceAll(RegExp(r"['،؟۔!.,;:?-]"), '');
      filteredText = filteredText.replaceAll(RegExp('"'), '');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  filteredText,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          );
        },
      );
    }

    List<Widget> splitSelectableWord(String text) {
      List<String> splitText = text.split(RegExp(r' '));
      return splitText
          .map(
            (word) => InkWell(
              onTap: () => showDialogueBox(word),
              child: Text(
                "$word ",
                style: const TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
          .toList();
    }

    List<Widget> splitSentence(String text) {
      List<String> splitText = text.split(RegExp(r'(?<=[۔])\s*'));
      return splitText
          .map(
            (sentence) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: splitSelectableWord(sentence),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                ),
              ],
            ),
          )
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Dialogue"),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/loginpage');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.lime,
        child: Column(
          children: [
            const DrawerHeader(
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/bloom.png'),
                radius: 50,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text("Dashboard"),
              onTap: () {
                Navigator.pushNamed(context, '/dashboard');
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat_bubble),
              title: const Text("Conversation"),
              onTap: () {
                Navigator.pushNamed(context, '/dashboard/conversation');
              },
            ),
            ListTile(
              leading: const Icon(Icons.lightbulb),
              title: const Text("Highlights"),
              onTap: () {
                Navigator.pushNamed(context, '/dashboard/highlights');
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: splitSentence(text),
          ),
        ),
      ),
    );
  }
}
