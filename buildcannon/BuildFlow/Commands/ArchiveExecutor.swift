//
//  ArchiveExecutor.swift
//  buildcannon
//
//  Created by Anderson Lucas C. Ramos on 13/06/18.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

class ArchiveExecutor: ExecutorProtocol {
    fileprivate let separator = " "
    fileprivate var commandExecutor: CommandExecutor!
    
    weak var delegate: ExecutorCompletionProtocol?
    
    required init() {
        
    }
    
    convenience init(project: DoubleDashComplexParameter?, target: DoubleDashComplexParameter?, sdk: DoubleDashComplexParameter?, scheme: DoubleDashComplexParameter, configuration: DoubleDashComplexParameter) {
        self.init()
        
        self.commandExecutor = CommandExecutor.init(path: ArchiveTool.toolPath, application: ArchiveTool.toolName, logFilePath: ArchiveTool.Values.archiveLogPath)
        self.commandExecutor.executeOnDirectoryPath = BuildcannonProcess.workingDir(wasSourceCopied: application.shouldCopyCode).path
        if let project = project {
            self.commandExecutor.add(parameter: SingleDashComplexParameter.init(parameter: self.projectParam(for: project), composition: project.composition, separator: self.separator))
        }
        if let target = target {
            self.commandExecutor.add(parameter: SingleDashComplexParameter.init(parameter: ArchiveTool.Parameters.targetParam, composition: target.composition, separator: self.separator))
        }
        self.commandExecutor.add(parameter: SingleDashComplexParameter.init(parameter: ArchiveTool.Parameters.schemeParam, composition: scheme.composition, separator: self.separator))
        self.commandExecutor.add(parameter: SingleDashComplexParameter.init(parameter: ArchiveTool.Parameters.sdkParam, composition: sdk?.composition ?? ArchiveTool.Values.sdkConfig, separator: self.separator))
        self.commandExecutor.add(parameter: SingleDashComplexParameter.init(parameter: ArchiveTool.Parameters.configurationParam, composition: configuration.composition, separator: self.separator))
        self.commandExecutor.add(parameter: NoDashParameter.init(parameter: ArchiveTool.Parameters.archiveParam))
        self.commandExecutor.add(parameter: SingleDashComplexParameter.init(parameter: ArchiveTool.Parameters.archivePathParam, composition: ArchiveTool.Values.archivePath, separator: self.separator))
        
        self.commandExecutor.add(parameter: SingleDashComplexParameter.init(parameter: ArchiveTool.Parameters.useModernBuildSystem,
                                                                            composition: self.isUseLegacyBuildSystemParameterPresent() ? "NO" : "YES",
                                                                            separator: "=")) // separator must be `=`
        
        let xcpretty = !Application.isVerbose && Application.isXcprettyInstalled
        if xcpretty {
            self.commandExecutor.add(parameter: NoDashParameter.init(parameter: "| xcpretty && exit ${PIPESTATUS[0]}"))
        }
    }
    
    fileprivate func isUseLegacyBuildSystemParameterPresent() -> Bool {
        return Application.processParameters.contains(where: {$0.parameter == InputParameter.Project.useLegacyBuildSystem.name})
    }
    
    fileprivate func projectParam(for parameter: DoubleDashComplexParameter) -> String {
        return parameter.buildParameter().contains(".xcworkspace") ?
            ArchiveTool.Parameters.workspaceParam : ArchiveTool.Parameters.projectParam
    }
    
    fileprivate func dispatchFinish(_ returnCode: Int) {
        Application.execute { [weak self] in
            if returnCode == 0 {
                self?.delegate?.executorDidFinishWithSuccess(self!)
            } else {
                self?.delegate?.executor(self!, didFailWithErrorCode: returnCode)
            }
        }
    }
    
    func execute() {
        Console.log(message: "Executing archive with command: \(self.commandExecutor.buildCommandString())")
        
        self.commandExecutor.execute(tag: "ArchiveExecutor") { [weak self] (returnCode, _) in
            self?.dispatchFinish(returnCode)
        }
    }
    
    func cancel() {
        self.commandExecutor.stop()
    }
}
