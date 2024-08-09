import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/setup.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/layout/setup_layout.dart';
import 'package:central_heating_control/app/presentation/widgets/loading_indicator.dart';
import 'package:central_heating_control/app/presentation/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  @override
  void initState() {
    super.initState();
    navigateToNextSequence();
  }

  void navigateToNextSequence() {
    final sc = Get.find<SetupController>();
    final list = sc.setupSequenceList;
    final currentSequence =
        sc.setupSequenceList.firstWhereOrNull((e) => !e.isCompleted);
    // final currentIndex =
    //     currentSequence == null ? 0 : list.indexOf(currentSequence);

    Future.delayed(
      Duration.zero,
      () {
        Get.offAndToNamed(
          currentSequence == null ? Routes.home : currentSequence.route,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SetupController>(builder: (sc) {
      // final list = sc.setupSequenceList;
      // final currentSequence =
      //     sc.setupSequenceList.firstWhereOrNull((e) => !e.isCompleted);
      // final currentIndex =
      //     currentSequence == null ? 0 : list.indexOf(currentSequence);
      return SetupLayout(
        title: 'Initial Setup'.tr,
        isExpanded: true,
        child: Center(
          child: LoadingIndicatorWidget(
            text: 'Please wait while initializing.',
          )
          // Column(
          //   children: sc.setupSequenceList
          //       .map((e) => TextButton(
          //           onPressed: () {
          //             Get.toNamed(e.route);
          //           },
          //           child: Text(e.title)))
          //       .toList(),
          // )
          ,
        ),
      );
      /* return Scaffold(
          body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: Theme.of(context).canvasColor,
            height: 64,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 20, top: 12),
                  child: const LogoWidget(
                    size: 180,
                  ),
                ),
                Container(
                  width: 200,
                  padding: const EdgeInsets.only(right: 20),
                  alignment: Alignment.centerRight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          currentSequence?.title ?? 'none',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      LinearProgressIndicator(
                        value: sc.progress,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: currentSequence?.contentIsExpanded ?? false
                ? (currentSequence?.className ?? Text('wait'))
                : PiScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 80),
                    child: (currentSequence?.className ?? Text('wait')),
                  ),
          ),
          Container(
            color: Theme.of(context).canvasColor,
            padding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 4),
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 50,
              child: OutlinedButton(
                  onPressed: () {}, //nextCallback,
                  child: // nextLabel == null
                      //?
                      Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 8),
                      Text('Next'.tr),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right),
                    ],
                  )
                  //: Text(nextLabel!),
                  ),
            ),
          ),
        ],
      ) */
      /*  Row(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: ListView.builder(
                  itemBuilder: (context, index) => Text(
                      '${sc.setupSequenceList[index].isCompleted ? '+' : '-'} ${sc.setupSequenceList[index].title}'),
                  itemCount: sc.setupSequenceList.length,
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: PageView(
                controller: pageController,
                children: sc.setupSequenceList.map((e) => e.className).toList(),
              ),
            )
          ],
        ), */
      /*  ); */
    });
  }
}
