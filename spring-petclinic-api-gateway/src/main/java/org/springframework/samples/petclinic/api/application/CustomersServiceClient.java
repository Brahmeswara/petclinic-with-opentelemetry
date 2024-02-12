/*
 * Copyright 2002-2021 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.springframework.samples.petclinic.api.application;

import lombok.RequiredArgsConstructor;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.samples.petclinic.api.dto.OwnerDetails;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;

import io.opentelemetry.api.trace.Span;
import io.opentelemetry.api.trace.Tracer;
import io.opentelemetry.context.Scope;
import reactor.core.publisher.Mono;


/**
 * @author Maciej Szarlinski
 */
@Component
@RequiredArgsConstructor
public class CustomersServiceClient {

    private final WebClient.Builder webClientBuilder;
    @Autowired
    private Tracer tracer ;

    public Mono<OwnerDetails> getOwner(final int ownerId) {
        Span span = tracer.spanBuilder("owners/ownerId").startSpan();
        try (Scope scope = span.makeCurrent()) {
            return webClientBuilder.build().get()
               .uri("http://customers-service/owners/{ownerId}", ownerId)
               .retrieve()
               .bodyToMono(OwnerDetails.class);
        } catch (Exception e) {
            span.recordException(e);
            throw e; 
        } finally {
            span.end();
        }
        /** 
        return webClientBuilder.build().get()
            .uri("http://customers-service/owners/{ownerId}", ownerId)
            .retrieve()
            .bodyToMono(OwnerDetails.class);
        */

    }
}