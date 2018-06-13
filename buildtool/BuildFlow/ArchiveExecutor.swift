//
//  ArchiveExecutor.swift
//  buildtool
//
//  Created by Anderson Lucas C. Ramos on 13/06/18.
//  Copyright © 2018 Anderson Lucas C. Ramos. All rights reserved.
//

import Foundation

struct ArchiveExecutor {
    fileprivate var commandExecutor: CommandExecutor!
    
    init(project: DoubleDashComplexParameter, scheme: DoubleDashComplexParameter) {
        var archive = CommandExecutor.init(path: "/usr/bin/", application: ArchiveTool.toolName)
        archive.add(parameter: SingleDashComplexParameter.init(parameter: self.projectParam(for: project), composition: project.composition))
        archive.add(parameter: SingleDashComplexParameter.init(parameter: ArchiveTool.Parameters.schemeParam, composition: scheme.composition))
        archive.add(parameter: SingleDashComplexParameter.init(parameter: ArchiveTool.Parameters.sdkParam, composition: ArchiveTool.Values.sdkConfig))
        archive.add(parameter: SingleDashComplexParameter.init(parameter: ArchiveTool.Parameters.configurationParam, composition: ArchiveTool.Values.configurationConfig))
        archive.add(parameter: NoDashParameter.init(parameter: ArchiveTool.Parameters.archiveParam))
        archive.add(parameter: SingleDashComplexParameter.init(parameter: ArchiveTool.Parameters.archivePathParam, composition: ArchiveTool.Values.archivePath))
        self.commandExecutor = archive
    }
    
    fileprivate func projectParam(for parameter: DoubleDashComplexParameter) -> String {
        return parameter.buildParameter().contains(".xcworkspace") ?
            ArchiveTool.Parameters.workspaceParam : ArchiveTool.Parameters.projectParam
    }
    
    mutating func execute() {
        self.commandExecutor.execute { (returnCode, output) in
            
        }
    }
    
    func cancel() {
        self.commandExecutor.stop()
    }
}