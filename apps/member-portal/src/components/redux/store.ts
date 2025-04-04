// Copyright (c) 2024 - 2025, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import { configureStore } from "@reduxjs/toolkit";
import { persistStore } from "redux-persist";
import cdsRequestSlice from "./cdsRequestSlice";
import cdsResponseSlice from "./cdsResponseSlice";
import loggedUserSlice from "./loggedUserSlice";

const store = configureStore({
  reducer: {
    cdsRequest: cdsRequestSlice,
    cdsResponse: cdsResponseSlice,
    loggedUser: loggedUserSlice,
  },
});

const persistor = persistStore(store);

export { store, persistor };
