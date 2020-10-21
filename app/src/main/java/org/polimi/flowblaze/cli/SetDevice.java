/*
 * Copyright 2020 Daniele Moro <daniele.moro@polimi.it>
 *                Davide Sanvito <davide.sanvito@neclab.eu>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.polimi.flowblaze.cli;


import org.apache.karaf.shell.api.action.Argument;
import org.apache.karaf.shell.api.action.Command;
import org.apache.karaf.shell.api.action.Completion;
import org.apache.karaf.shell.api.action.lifecycle.Service;
import org.onosproject.cli.AbstractShellCommand;
import org.onosproject.cli.net.DeviceIdCompleter;
import org.onosproject.net.DeviceId;
import org.polimi.flowblaze.FlowblazeService;

@Service
@Command(scope = "flowblaze", name = "set-device",
        description = "Setup the FlowBlaze Device")
public class SetDevice extends AbstractShellCommand {

    @Argument(name = "deviceId", description = "Device ID", required = true)
    @Completion(DeviceIdCompleter.class)
    String deviceId = null;

    @Override
    protected void doExecute() throws Exception {
        FlowblazeService flowblazeService = get(FlowblazeService.class);
        flowblazeService.setFlowblazeDeviceId(DeviceId.deviceId(deviceId));
    }

}