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

package org.polimi.flowblaze;

import org.onosproject.net.DeviceId;

import java.util.List;

public interface FlowblazeService {

    /**
     * Set the FlowBlaze device ID.
     * @param deviceId The device ID
     * @return True if value is accepted, False otherwise
     */
    boolean setFlowblazeDeviceId(DeviceId deviceId);

    /**
     * Setup conditions on the FlowBlaze device.
     * @param conditions List of conditions to set up
     * @return True if conditions pushed to the FlowStore, False otherwise
     */
    boolean setupConditions(List<EfsmCondition> conditions);

    /**
     * Setup a packet action to be applied on the packet as a result of an EFSM transition.
     * @param pktAction The packet action ID
     * @param action The packet action name defined in the P4 file
     * @return True if packet action pushed to the FlowStore, False otherwise
     */
    boolean setupPktAction(byte pktAction, String action);

    /**
     * Setup an EFSM Table entry on the FlowBlaze device.
     * This corresponds to setting up an EFSM transition.
     * @param match State, conditions and packet header matching for the EFSM transition
     * @param nextState The next state of the EFSM transition
     * @param operations The EFSM operation (update function) to be applied on the EFSM transition
     * @param pktAction The ID of the packet action to be applied on the EFSM transition
     * @return True if EFSM entry pushed to the FlowStore, False otherwise
     */
    boolean setupEfsmTable(EfsmMatch match, int nextState, List<EfsmOperation> operations, byte pktAction);

    /**
     * Remove all the FlowBlaze entries from the FlowBlaze device.
     * @return True if the FlowBlaze device is set, False otherwise
     */
    boolean resetFlowblaze();

    /**
     * Remove the Packet Action entries from the FlowBlaze device.
     * @return True if the FlowBlaze device is set, False otherwise
     */
    boolean resetPktActions();

    /**
     * Remove the Conditions from the FlowBlaze device.
     * @return True if the FlowBlaze device is set, False otherwise
     */
    boolean resetConditions();

    /**
     * Remove the EFSM entries from the FlowBlaze device.
     * @return True if the FlowBlaze device is set, False otherwise
     */
    boolean resetEfsmEntries();

    /**
     * Return the set FlowBlaze device ID.
     * @return FlowBlaze device ID
     */
    DeviceId getFlowBlazeDeviceId();

}
