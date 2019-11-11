#!/bin/bash

pod repo add WyhSpecs https://github.com/XiaoWuTongZhi/WyhPodSpecs.git
pod repo push WyhSpecs WyhUIToast.podspec --allow-warnings --verbose --use-libraries
pod repo update WyhSpecs 